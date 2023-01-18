note
	description: "Objects that create and select objects to be used in adaptive random testing"
	author: "Ilinca Ciupa"
	date: "$Date$"
	revision: "$Revision$"

class AUT_ART_INPUT_CREATOR

inherit
	AUT_RANDOM_INPUT_CREATOR
		redefine
			make, step
		end

	EXCEPTIONS
		export {NONE} all end

create
	make

feature {NONE} -- Initialization

	make (a_system: like system; an_interpreter: like interpreter; a_feature_table: like feature_table)
			-- Create new input creator for adaptive random testing.
		do
			Precursor (a_system, an_interpreter, a_feature_table)
			create {DS_ARRAYED_LIST [BOOLEAN]} should_store_receivers.make_default
			create distances.make_default
		end

feature -- Execution

	step is
		local
			i: INTEGER
			receiver: ITP_VARIABLE
			conforming_variable_list: DS_LIST [ITP_VARIABLE]
			feature_name: STRING
			response: AUT_NORMAL_RESPONSE
			num_new_variables: INTEGER
			new_vars: DS_LIST [ITP_VARIABLE]
		do
			if object_creator /= Void then
				object_creator.step
				if not object_creator.has_next_step then
					object_creator := Void
				end
			elseif receivers.count < types.count then
				random.forth
				i := random.item  \\ 2
				if i = 1 then
					create_object_creator
				elseif feature_under_test = Void then -- we are in diversify mode
					receiver := interpreter.random_conforming_variable (types.item (receivers.count + 1))
					if receiver = Void then
						create_object_creator
					else
						receivers.force_last (receiver)
						should_store_receivers.force_last (True)
					end
				else -- we are in testing mode, so we select objects to be used in tests based on ART
					conforming_variable_list := interpreter.conforming_variables (types.item (receivers.count + 1))
					if conforming_variable_list.is_empty then
						create_object_creator
					else
							-- See if any objects have already been used for testing this feature.
						feature_name := feature_under_test.implementation_class.name.name + "." + feature_under_test.name.name
						interpreter.retrieve_number_of_used_objects_for_feature (feature_name, receivers.count + 1)
						if not interpreter.last_response.is_bad then
							response ?= interpreter.last_response
							if response /= Void then
								if not response.output.is_integer then
									print ("error: received non-number response for retrieve-number-of-used-objects-for-feature request.%N")
									die (0)
								else
									num_new_variables := response.output.to_integer
									if num_new_variables < 0 then
										print ("error: received negative number response for retrieve-number-of-used-objects-for-feature request.%N")
										die (0)
									elseif num_new_variables = 0 then
											-- This feature has not been tested before.
										receiver := interpreter.random_conforming_variable (types.item (receivers.count + 1))
										receivers.force_last (receiver)
										should_store_receivers.force_last (True)
									else -- num_new_variables > 0
										create {DS_ARRAYED_LIST [ITP_VARIABLE]} new_vars.make_default
										from
											i := 1
										until
											i > num_new_variables
										loop
											new_vars.force_last (interpreter.new_variable)
											i := i + 1
										end
										interpreter.retrieve_used_objects_for_feature (feature_name, receivers.count + 1, new_vars)
										if not interpreter.last_response.is_bad then
											response ?= interpreter.last_response
											if response /= Void then
													-- There are some already used objects for testing this feature.
												receiver := select_furthest_away (conforming_variable_list, new_vars)
												from
													new_vars.start
												until
													new_vars.after
												loop
													interpreter.variable_type_table.remove (new_vars.item_for_iteration)
													new_vars.forth
												end
											end
										else
												print ("error: interpreter could not assign already used objects to variables.%N")
												receiver := interpreter.random_conforming_variable (types.item (receivers.count + 1))
												should_store_current := True
										end
										receivers.force_last (receiver)
										should_store_receivers.force_last (should_store_current)
									end
								end
							end
						end
					end
				end
			else
				has_next_step := False
			end
		end

feature -- Updating

	set_feature (a_feature: ET_FEATURE) is
			-- Set `feature_under_test' to `a_feature'.
		require
			a_feature_not_void: a_feature /= Void
		do
			feature_under_test := a_feature
		ensure
			feature_under_test_set: feature_under_test = a_feature
		end

	set_distances (a_distances: DS_HASH_TABLE [DS_HASH_TABLE [DOUBLE, STRING], STRING]) is
			-- Set `distances' to `a_distances'.
		require
			a_distances_not_void: a_distances /= Void
		do
			distances := a_distances
		ensure
			distances_set: distances = a_distances
		end


feature -- Access

	should_store_receivers: DS_LIST [BOOLEAN]
			-- Indicates whether the receiver on the corresponding position in the `receivers' list
			-- should be stored to disk as part of recording objects used in tests


feature {NONE} -- Implementation

	select_furthest_away (available, used: DS_LIST [ITP_VARIABLE]): ITP_VARIABLE is
			-- Element of `available' that has the highest average distance
			-- to all elements of `used'.
		require
			at_lest_one_available: available /= Void and then not available.is_empty
			used_not_void: used /= Void
		local
			total_distance, max, temp_distance: DOUBLE
			i: INTEGER
			var1, var2: ITP_VARIABLE
			already_used, l_should_store_current, var1_has_changed: BOOLEAN
			var2_name: STRING
			l_distances, new_distances: DS_HASH_TABLE [DOUBLE, STRING]
		do
			should_store_current := True
			from
				available.start
			until
				available.after
			loop
				if not used.has (available.item_for_iteration) then
					var1 ?= available.item_for_iteration
					if var1 /= Void then
						total_distance := 0
						l_should_store_current := True
						already_used := False
						var1_has_changed := True
						from
							used.start
							i := 0
						until
							used.after or already_used
						loop
							var2 ?= used.item_for_iteration
							if var2 /= Void then
								var2_name := feature_under_test.implementation_class.name.name + "." + feature_under_test.name.name +
									"_" + (receivers.count + 1).out + "_" + used.index.out
								if var1_has_changed then
									temp_distance := distance_from_interpreter (var1.name, var2.name)
									if distances.has (var2_name) then
										l_distances := distances.item (var2_name)
										if l_distances.has (var1.name) then
											if l_distances.item (var1.name) = temp_distance then
												var1_has_changed := False
											else
												l_distances.force (temp_distance, var1.name)
											end
										else
											l_distances.force (temp_distance, var1.name)
										end
									else
										create new_distances.make_default
										new_distances.force (temp_distance, var1.name)
										distances.force (new_distances, var2_name)
									end
								else
									if distances.has (var2_name) then
										if distances.item (var2_name).has (var1.name) then
											temp_distance := distances.item (var2_name).item (var1.name)
										else
											temp_distance := distance_from_interpreter (var1.name, var2.name)
											distances.item (var2_name).force (temp_distance, var1.name)
										end
									else
										temp_distance := distance_from_interpreter (var1.name, var2.name)
										create new_distances.make_default
										new_distances.force (temp_distance, var1.name)
										distances.force (new_distances, var2_name)
									end
								end
								if temp_distance = 0 then
									already_used := True
									l_should_store_current := False
								elseif temp_distance = Ref_distance_only then
									l_should_store_current := False
								end
								total_distance := total_distance + temp_distance
								i := i + 1
							end
							used.forth
						end
						total_distance := total_distance / i
						if not already_used and total_distance > max then
							Result := available.item_for_iteration
							max := total_distance
							should_store_current := l_should_store_current
							if total_distance = Max_distance then
								available.go_i_th (available.count)
							end
						end
					end
				end
				available.forth
			end
			if Result = Void then -- All available objects have distance 0 to all used objects
				random.forth
				Result := available.item (random.item \\ available.count + 1)
				should_store_current := False
			end
		ensure
			Result_not_void: Result /= Void
			Result_in_available: available.has (Result)
		end


	distance_from_interpreter (var1, var2: STRING): DOUBLE is
			-- Distances between the objects wrapped by `var1' and `var2', computed by interpreter
		require
			var1_valid: var1 /= Void and then not var1.is_empty
			var2_valid: var2 /= Void and then not var2.is_empty
		local
			response: AUT_NORMAL_RESPONSE
		do
			interpreter.get_object_distance (var1, var2)
			if not interpreter.last_response.is_bad then
				response ?= interpreter.last_response
				if response = Void or else response.output = Void or else not response.output.is_double then
					print ("error: interpreter inconsistent response%N")
					die (0)
				else
					Result := response.output.to_double
				end
			end
		end

	feature_under_test: ET_FEATURE
			-- Feature that is being tested (for which we are creating the input)
			-- Will be Void if current input creator is being used in diversify mode

	should_store_current: BOOLEAN
			-- Should the currently furthest away object be stored to disk
			-- as part of recording objects used in tests?

	distances: DS_HASH_TABLE [DS_HASH_TABLE [DOUBLE, STRING], STRING]
			-- Calculated distances: keys are names of stored variables (in the form "class_name.feature_name_position")
			-- and items are hashtables, whose keys are names of alive variables (in the usual form of v_1, etc)
			-- and items are calculated distances

	Ref_distance_only: DOUBLE is
			-- Distance between 2 objects for which all expanded fields are equal,
			-- only reference fields have different values
		once
			Result := 0.1/3
		end

	Max_distance: DOUBLE is 1.0
			-- Maximum possible value for the distance between 2 objects


invariant
	should_store_receivers_not_void: should_store_receivers /= Void

note
	copyright: "Copyright (c) 1984-2022, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
