note
	description: "This class extracts heap states from counterexamples."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_CE_STATE_OF_ROUTINE

inherit
	E2B_SHARED_CONTEXT
		redefine
			out
		end
create
	make

feature -- Initialize

	make (a_target_feature: detachable FEATURE_I; a_target_class: detachable CLASS_C; a_ce: E2B_BOOGIE_COUNTEREXAMPLE; a_heap_value: STRING)
		do
			-- print ("E2B_CE_STATE_OF_ROUTINE.make%N")
			-- print ("extract state for: " + a_target_feature.feature_name_32.to_string_8 + " " + a_target_class.name + " " + a_heap_value +"%N")
			start_timer
			target_feature := a_target_feature
			target_class := a_target_class
			ce := a_ce
			heap_value := a_heap_value

			create state_values.make (0)
			create alias_groups.make (0)
			create missing_values.make_empty

			get_state
			-- print ("etract state time: " + current_timer.out + "%N")
--			across state_values.current_keys as k loop
--				print (k + "->" + state_values [k] + "%N")
--			end
			stop_timer
		end

feature -- Data

	ce: E2B_BOOGIE_COUNTEREXAMPLE
			-- Mapping from class.routine to a set of counterexamples

	heap_value: STRING
			-- Symbolic value of the heap state

	target_feature: FEATURE_I
			-- Feature under verification

	target_class: CLASS_C
			-- Class of the target feature

	alias_groups: HASH_TABLE [ARRAY [STRING], STRING]
			-- Mapping from an abstract value (object) to a list of references

	state_values: HASH_TABLE [STRING, STRING]
			-- Mapping from objects or object fields to the corresponding value

	missing_values: ARRAY [STRING]
			-- A set of variables whose values are missing

	state_index: INTEGER
			-- Index of the current state; position of the state in the corresponding ce trace
		local
			i: INTEGER
		do
			from
				i := 1; ce.heap_values.start
			until
				i = ce.heap_values.count
			loop
				if ce.heap_values.at (ce.heap_values.key_for_iteration).same_string (heap_value) then
					Result := i
					i := ce.heap_values.count
				else
					i := i + 1
					ce.heap_values.forth
				end
			end
		end

feature -- Get initial state

	get_state
			-- Obtain the object fields based on the heap function
		local
			arg_name: STRING
			arg_type: TYPE_A
			i: INTEGER
		do
			arg_name := "";

				-- get Void value
			state_values ["Void"] := ""
			state_values ["Void"].copy (ce.constants_values ["Void"])

				-- get initial state of the current object
			get_object_initial_state ("Current", target_class.actual_type)

				-- get initial state of each arguments
			if attached target_feature and then attached target_feature.arguments then
				from
					i := 1
				until
					i > target_feature.arguments.count
				loop -- Minimize each argument of the target feature
					arg_name := target_feature.arguments.item_name_32 (i).to_string_8
					arg_type := target_feature.arguments.array_item (i - 1)
					get_object_initial_state (arg_name, arg_type)
					i := i + 1
				end
			end

			compute_alias

			-- Function values
			get_function_values

			-- Ids of passed blocks
			if heap_value ~ ce.heap_values.iteration_item (ce.heap_values.count - 1) and not ce.passed_blocks_values.is_empty then
				across ce.constants_values.current_keys as k loop
					if k.same_string ("passed_blocks") then
						-- TODO Li: recover state_values.extend (ce.constants_values [k], "(Current).passed_blocks")
					end
				end
			end

		end

	compute_alias
			-- Store the aliases into the same group
		local
			name, value: STRING
		do
				-- print ("E2B_INITIAL_STATE_OF_ROUTINE.compute_alias%N")
			alias_groups.wipe_out

			across state_values.current_keys as k loop
				name := k
				value := state_values [name]

				if is_abstract_value (value) then
					if alias_groups.has (value) then
						alias_groups [value].compare_objects
						if (not alias_groups [value].has (name)) then
							alias_groups [value].force (name, alias_groups [value].count + 1)
						end
					else
						alias_groups.extend (<<name>>, value)
					end
				end
			end

		end

	get_function_values
		-- Get the value for functions
		local
			l_func_name: STRING
		do
			l_func_name := ""
			across ce.function_values.current_keys as k loop
				if k.has_substring (heap_value) then
					l_func_name.copy (k.split(' ').first)
					state_values.extend (ce.function_values [k], l_func_name)
				end
			end
		end

	safe_field_type (field_type: STRING): STRING
			-- Return the safe type of a data field
		do
			field_type.to_lower
			Result := field_type
			if field_type.has ('_') then
				Result := field_type.split ('_').first
			end
		end

	safe_type (type: STRING): STRING
			-- Convert the name of container type
		local
			t, item_type: STRING
			tuple_field_types: LIST [STRING]
			i: INTEGER
		do
			t := ""; Result := ""; item_type := ""
			if type.has_substring ("^") then
				if type.has_substring ("V_ARRAY") then
					item_type.copy (type.split ('^') [2])
					t := t + "V_ARRAY" + "[" + item_type + "]"
				elseif type.has_substring ("SIMPLE_ARRAY") then
					item_type.copy (type.split ('^') [2])
					t := t + "SIMPLE_ARRAY" + "[" + item_type + "]"
				elseif type.has_substring ("LIST") then
					item_type.copy (type.split ('^') [2])
					t := t + "LIST" + "[" + item_type + "]"
				elseif type.has_substring ("TUPLE") then
					tuple_field_types := type.split ('#')
					tuple_field_types [1].copy (tuple_field_types [1].split ('^').last)
					t := t + "TUPLE" + "["

					from
						i := 1
					until
						i = tuple_field_types.count
					loop
						t := t + tuple_field_types [i] + ","
						i := i + 1
					end

					t := t + tuple_field_types [i].split ('^').first + "]"
				end
			else
				t := type
			end
			Result.copy (t)
		end

feature -- Get initial values

	value_named (a_var: STRING): STRING
			-- Initial value of `a_var'
		require
			is_included: state_values.has (a_var)
		do
			Result := state_values [a_var]
		end

	container_size_named (a_var: STRING): STRING
			-- Size of the container named `a_var'
			--require
			--	is_included: initial_values.has (a_var + ".sequence") and then ce.seq_lengths.has (initial_values [a_var + ".sequence"])
		do
				-- get a's size
				-- if ce.class_field_relations.has (object_type.name + "." + field_name)
				--	and ce.heap_function.has (initial_values [object_name] + ", " + ce.class_field_relations [object_type.base_class.name + "." + field_name]) then
				--	field_value.copy (ce.heap_function [initial_values [object_name] + ", " + ce.class_field_relations [object_type.base_class.name + "." + field_name]])
				-- end

			Result := ce.seq_lengths [state_values [a_var + ".sequence"]]
		end

	container_item_named (a_var: STRING; i: STRING): STRING
			-- The ith element of the container named `a_var'
		require
			is_included: state_values.has (a_var) and then ce.seq_lengths.has (state_values [a_var + ".sequence"])
		do
			Result := ce.seq_item [state_values [a_var + ".sequence"] + ", " + i]
		end

	get_object_value (object_name: STRING): STRING
			-- Retrieve the value of an object in the counterexample model
		require
			is_included: ce.constants_values.has (object_name)
		do
			Result := ce.constants_values [object_name]
		end

	get_object_fields (object_name: STRING; object_type: TYPE_A)
			-- Obtain all fields of an object
		local
			i, j: INTEGER
			field_name, field_value: STRING
			field_type: TYPE_A
			l_seq, l_length: STRING
		do
			field_name := ""; field_value := ""
			if object_type.has_associated_class then
				from
					i := 1
				until
					i > object_type.base_class.skeleton.count
				loop
					field_name := object_type.base_class.skeleton [i].attribute_name -- object.field
					field_type := object_type.base_class.skeleton [i].type_i

					if not is_ignored_field (field_name, field_type) then
							-- TODO: check the fields of SIMPLE_ARRAY?
							-- sequence is field of SIMPLE_ARRAY?
						if ce.class_field_relations.has (object_type.name + "." + field_name)
							and ce.heap_function.has (heap_value + ", " + state_values [object_name] + ", " + ce.class_field_relations [object_type.name + "." + field_name]) then
							field_value.copy (ce.heap_function [heap_value + ", " + state_values [object_name] + ", " + ce.class_field_relations [object_type.name + "." + field_name]])
						else
							field_value := default_value (field_type)
						end

						if field_type.is_basic then
							state_values [object_name + "." + field_name] := ""
							state_values [object_name + "." + field_name].copy (field_value)
						elseif field_name.same_string ("sequence") and field_type.name.has_substring ("MML_SEQUENCE") then
								-- TODO: extract models for other MML classes, set, bag, relation, pair
								-- if ce.seq_lengths.has (field_value) and not ce.seq_item.is_empty then
								-- Get sequence count
							if ce.seq_lengths.has (field_value) then
								l_length := ce.seq_lengths [field_value]
							else
								l_length := "0"
							end

							state_values [object_name + "." + field_name + ".count"] := ""
							state_values [object_name + "." + field_name + ".count"].copy (l_length)

								-- Get sequence items

							l_seq := "["
							if l_length.to_integer > 0 then

								from
									j := 1
								until
									j > l_length.to_integer - 1 or j > 10 -- TODO Li: this is a walkaround to prevent large sequence
								loop
									if ce.seq_item.has (field_value + ", " + j.out) then
											-- concatenate each sequence item
										l_seq := l_seq + ce.seq_item [field_value + ", " + j.out] + ","
									else
										l_seq := l_seq + default_value (create {INTEGER_A}.make (8)).out + "," -- TODO Li: support integer type only
									end
									j := j + 1
								end

								if ce.seq_item.has (field_value + ", " + j.out) then
										-- concatenate each sequence item
									l_seq := l_seq + ce.seq_item [field_value + ", " + j.out]
								else
									l_seq := l_seq + default_value (create {INTEGER_A}.make (8)).out
								end
							end
							l_seq := l_seq + "]"

							state_values [object_name + "." + field_name] := ""
							state_values [object_name + "." + field_name].copy (l_seq)
								-- end
						elseif is_reference_type (field_type) then
							get_object_fields (object_name + "." + field_name, field_type)
						end

					end
					i := i + 1
				end
			end
		end

	default_value (field_type: TYPE_A): STRING
			-- Default value of `field_type'
		do
			if field_type.is_integer then
				Result := "0"
			elseif field_type.is_boolean then
				Result := "False"
			else
				Result := ""
			end
		end

	get_object_initial_state (object_name: STRING; object_type: TYPE_A)
			-- Obtain the initial state of an object
		do
				-- print ("E2B_INITIAL_STATE_OF_ROUTINE.get_object_initial_state%N")
			state_values [object_name] := ""
			state_values [object_name].copy (get_object_value (object_name))

			if is_reference_type (object_type) then
				get_object_fields (object_name, object_type)
					--elseif is_container_type (object_type) then
					--	get_container_sequence (object_name, object_type)
			end
		end

	get_container_sequence (object_name: STRING; object_type: TYPE_A)
			-- Obtain the initial state of a container
		do
				-- value of object_name.sequence
				-- print ("get the value of sequence of type: " + object_type.name + "%N")
		end

feature -- Properties checking

	is_aliased_with_existed_object (object_name: STRING): BOOLEAN
			-- Is the given object an alias with one of the instantiated objects?
		local
			object_value: STRING
		do
			object_value := ""
			object_value.copy (state_values [object_name])
			Result := alias_groups.has (object_value) and not alias_groups [object_value] [1].same_string (object_name)
		end

	is_container_type (object_type: TYPE_A): BOOLEAN
			-- Is the given type a container type?
		local
			type: STRING
		do
			type := object_type.name
			Result := False
			if type.has_substring ("V_ARRAY") or type.has_substring ("SIMPLE_ARRAY") or type.has_substring ("SEQUENCE") or
				type.same_string ("LIST") or type.same_string ("BAG") or
				type.same_string ("SET") or type.same_string ("MAP") or
				type.same_string ("RELATION") or type.same_string ("TABLE") or
				type.same_string ("INTERVAL") or type.same_string ("TUPLE")
			then
				Result := True
			end
		end

	is_abstract_value (value: STRING): BOOLEAN
			-- Is the `value' an abstract value?
		do
			Result := value.has_substring ("T@U")
		end

	is_basic_type (type: TYPE_A): BOOLEAN
			-- Is the given type a basic type?
		local
			type_name: STRING
		do
			Result := False
			if type.has_associated_class then
				type_name := type.base_class.name
				if type_name.same_string ("INTEGER") or type_name.same_string ("INTEGER_32") or
					type_name.same_string ("NATURAL") or type_name.same_string ("NATURAL_32") or type_name.same_string ("NATURAL_64") or
					type_name.same_string ("BOOLEAN") or
					type_name.same_string ("CHARACTER") or type_name.same_string ("REAL") then
					Result := True
				end
			end

		end

	is_reference_type (type: TYPE_A): BOOLEAN
			-- Is the given type a reference type?
		do
			Result := not is_basic_type (type)
		end

	is_ignored_field (name: STRING; type: TYPE_A): BOOLEAN
		do
			Result := (type.name.same_string ("V_LINKABLE_INTEGER") and (name.same_string ("right"))) or -- `right' in V_LINKABLE_INTEGER
				(type.name.same_string ("V_DOUBLY_LINKABLE_INTEGER") and (name.same_string ("left") or name.same_string ("right"))) or
				name.last_index_of ('_', name.count) = name.count or -- ghost attributes
					-- type.name.has_substring ("MML_SEQUENCE") or
				type.name.has_substring ("MML_SET") or
				type.name.has_substring ("MML_BAG") or
				type.name.has_substring ("MML_INTERVAL") or
				type.name.has_substring ("MML_MAP") or
				type.name.has_substring ("MML_PAIR") or
				type.name.has_substring ("MML_RELATION")
		end

feature
	out: STRING
			-- String representation of a ce state
		do
			Result := ""
			across state_values.current_keys as k loop
				Result := Result + k + " " + state_values [k] + "%N"
			end
		end

note
	license: "GNU General Public License"
	license_name: "GPL"
	EIS: "name=GPL", "src=https://www.gnu.org/licenses/gpl.html", "tag=license"
	copying: "[
								This program is free software; you can redistribute it and/or modify it under the terms of
								the GNU General Public License as published by the Free Software Foundation; either version 1,
								or (at your option) any later version.
						
								This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
								without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
								See the GNU General Public License for more details.
			
								You should have received a copy of the GNU General Public License along with this program.
								If not, see <https://www.gnu.org/licenses/>.
		]"

end

