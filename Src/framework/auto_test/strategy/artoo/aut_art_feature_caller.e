note
	description: "Objects that call features in adaptive random testing"
	author: "Ilinca Ciupa"
	date: "$Date$"
	revision: "$Revision$"

class AUT_ART_FEATURE_CALLER

inherit
	AUT_RANDOM_FEATURE_CALLER
		redefine
			target_creator, invoke, create_target_creator, feature_caller
		end

create
	make

feature -- Access

	target_creator: AUT_ART_INPUT_CREATOR
			-- Input creator used to create arguments for feature call
			-- (Uses an adaptive random testing strategy to select the objects that will be used)

	feature_caller: AUT_ART_FEATURE_CALLER

	set_distances (a_distances: DS_HASH_TABLE [DS_HASH_TABLE [DOUBLE, STRING], STRING]) is
			-- Set `distances' to `a_distances'.
		require
			a_distances_not_void: a_distances /= Void
		do
			distances := a_distances
		ensure
			distances_set: distances = a_distances
		end

feature {NONE} -- Feature invocation

	invoke is
			-- Invoke feature to call.
		local
			list: DS_LIST [ITP_EXPRESSION]
			query: ET_QUERY
			objects, objects_to_store: DS_LIST [ITP_EXPRESSION]
			feature_name: STRING
			should_store_target: BOOLEAN
			normal_response: AUT_NORMAL_RESPONSE
		do
			list := input_creator.receivers
			if target = Void then
				target ?= list.first
					-- If `list.first' represents `Void' (ITP_REFERENCE), target will be `Void'.
				list.remove_first
				should_store_target := input_creator.should_store_receivers.first
				input_creator.should_store_receivers.remove_first
			else
				should_store_target := True
			end
			if target /= Void then
					-- Store the objects that will be used in the call.
				create {DS_ARRAYED_LIST [ITP_EXPRESSION]} objects.make_from_linear (input_creator.receivers)
				objects.force_first (target)
				input_creator.should_store_receivers.force_first (should_store_target)
				if interpreter.variable_type (target).direct_base_class (universe).name.name.is_equal (universe.none_class.name.name) then
						-- Only store target (without arguments).
					from
						input_creator.should_store_receivers.start
						input_creator.should_store_receivers.forth
					until
						input_creator.should_store_receivers.after
					loop
						input_creator.should_store_receivers.replace_at (False)
						input_creator.should_store_receivers.forth
					end
				end
				feature_name := feature_.implementation_class.name.name + "." + feature_.name.name

				create {DS_ARRAYED_LIST [ITP_EXPRESSION]} objects_to_store.make_default
				from
					objects.start
				until
					objects.after
				loop
					if (1 <= objects.index and objects.index <= input_creator.should_store_receivers.count) and then input_creator.should_store_receivers.item (objects.index) then
						objects_to_store.force_last (objects.item_for_iteration)
					else
						objects_to_store.force_last (Void)
					end
					objects.forth
				end
				interpreter.store_used_objects_for_feature (feature_name, objects_to_store)

				if not interpreter.variable_type (target).direct_base_class (universe).name.name.is_equal (universe.none_class.name.name) then
						-- Mark the feature as being called and print a message showing its selection.
					queue.mark (create {AUT_FEATURE_OF_TYPE}.make (feature_, interpreter.variable_type (target)))
					error_handler.report_feature_selection (type, feature_)

						-- Actually call the feature.
					query ?= feature_
					if query /= Void then
						receiver := interpreter.new_variable
						interpreter.invoke_and_assign_feature (receiver, query, target, input_creator.receivers)
					else
						interpreter.invoke_feature (feature_, target, input_creator.receivers)
					end
				end
			end
		end

	create_target_creator
			-- Create `input_creator' for use in non-diversify mode.
		local
			i: INTEGER
			count: INTEGER
		do
			create input_creator.make (universe, interpreter)
			input_creator.add_type (type)
			if feature_.arguments /= Void then
				from
					i := 1
					count := feature_.arguments.count
				until
					i > count
				loop
					input_creator.add_type (feature_.arguments.item (i).type.base_type (type, universe))
					i := i + 1
				end
			end
			input_creator.set_feature (feature_)
			input_creator.set_distances (distances)
			input_creator.start
		end

feature {NONE} -- Implementation

	distances: DS_HASH_TABLE [DS_HASH_TABLE [DOUBLE, STRING], STRING]
			-- Calculated distances: keys are names of stored variables (in the form "class_name.feature_name_position")
			-- and items are hashtables, whose keys are names of alive variables (in the usual form of v_1, etc)
			-- and items are calculated distances

;note
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
