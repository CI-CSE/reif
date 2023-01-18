note
	description: "This class generates tests and writes them in the output file."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_INITIAL_STATE_OF_ROUTINE

create
	make

feature -- Initialize

	make (a_target_feature: detachable FEATURE_I; a_target_class: detachable CLASS_C; a_ce: E2B_BOOGIE_COUNTEREXAMPLE)
		do
			target_feature := a_target_feature
			target_class := a_target_class
			ce := a_ce

			create initial_values.make (0)
			create alias_groups.make (0)
			create missing_values.make_empty

			get_initial_state
		end

feature -- Data

	ce: E2B_BOOGIE_COUNTEREXAMPLE
			-- Mapping from class.routine to a set of counterexamples

	target_feature: FEATURE_I
			-- Feature under verification

	target_class: CLASS_C
			-- Class of the target feature

	alias_groups: HASH_TABLE [ARRAY [IMMUTABLE_STRING_32], IMMUTABLE_STRING_32]
			-- Mapping from an abstract value (object) to a list of references

	initial_values: HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
			-- Mapping from objects or object fields to the corresponding value

	missing_values: ARRAY [IMMUTABLE_STRING_32]
			-- A set of variables whose values are missing

feature -- Get initial state

	get_initial_state
			-- Obtain the object fields based on the heap function
		local
			arg_name: STRING_32
			arg_type: TYPE_A
			i: INTEGER
		do
			arg_name := "";

				-- get initial state of the current object
			get_object_initial_state ("Current", target_class.actual_type)

				-- get initial state of each arguments
			if attached target_feature and then attached target_feature.arguments then
				from
					i := 1
				until
					i > target_feature.arguments.count
				loop -- Minimize each argument of the target feature
					arg_name := target_feature.arguments.item_name_32 (i)
					arg_type := target_feature.arguments.array_item (i - 1)
					i := i + 1
					get_object_initial_state (arg_name, arg_type)
				end
			end

			compute_alias
		end

	compute_alias
			-- Store the aliases into the same group
		local
			name, value: STRING_32
		do
			alias_groups.make (0)

			across initial_values.current_keys as k loop
				name := k
				value := initial_values [name]

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

	safe_field_type (field_type: STRING_32): STRING_32
			-- Return the safe type of a data field
		do
			field_type.to_lower
			Result := field_type
			if field_type.has ('_') then
				Result := field_type.split ('_').first
			end
		end

	safe_type (type: STRING_32): STRING_32
			-- Convert the name of container type
		local
			t, item_type: STRING_32
			tuple_field_types: LIST [STRING_32]
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

	value_named (a_var: STRING_32): STRING_32
			-- Initial value of `a_var'
		require
			is_included: initial_values.has (a_var)
		do
			Result := initial_values [a_var]
		end

	container_size_named (a_var: STRING_32): STRING_32
			-- Size of the container named `a_var'
			--require
			--	is_included: initial_values.has (a_var + ".sequence") and then ce.seq_lengths.has (initial_values [a_var + ".sequence"])
		do
				-- get a's size
				-- if ce.class_field_relations.has (object_type.name + "." + field_name.to_string_8)
				--	and ce.heap_function.has (initial_values [object_name] + ", " + ce.class_field_relations [object_type.base_class.name + "." + field_name.to_string_8]) then
				--	field_value.copy (ce.heap_function [initial_values [object_name] + ", " + ce.class_field_relations [object_type.base_class.name + "." + field_name.to_string_8]])
				-- end

			Result := ce.seq_lengths [initial_values [a_var + ".sequence"]]

		end

	container_item_named (a_var: STRING_32; i: STRING_32): STRING_32
			-- The ith element of the container named `a_var'
		require
			is_included: initial_values.has (a_var) and then ce.seq_lengths.has (initial_values [a_var + ".sequence"])
		do
			print (a_var + " at " + i.out + "%N")

			Result := ce.seq_item [initial_values [a_var + ".sequence"] + ", " + i]
		end

	get_object_value (object_name: STRING_32): STRING_32
			-- Retrieve the value of an object in the counterexample model
		require
			is_included: ce.constants_values.has (object_name)
		do
			-- Current.balance
			Result := ce.constants_values [object_name]
		end

	get_object_fields (object_name: STRING_32; object_type: TYPE_A)
			-- Obtain all fields of an object
		local
			i: INTEGER
			field_name, field_value: STRING_32
			field_type: TYPE_A

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
					i := i + 1

					if ce.class_field_relations.has (object_type.name + "." + field_name.to_string_8)
						and ce.heap_function.has (initial_values [object_name] + ", " + ce.class_field_relations [object_type.name + "." + field_name.to_string_8]) then

						field_value.copy (ce.heap_function [initial_values [object_name] + ", " + ce.class_field_relations [object_type.name + "." + field_name.to_string_8]])

					end

					initial_values [object_name + "." + field_name] := ""
					initial_values [object_name + "." + field_name].copy (field_value)

					if is_reference_type (field_type) then
						get_object_fields (object_name + "." + field_name, field_type)
					end
				end
			end
		end

	get_object_initial_state (object_name: STRING_32; object_type: TYPE_A)
			-- Obtain the initial state of an object
		do
			initial_values [object_name] := ""
			initial_values [object_name].copy (get_object_value (object_name))

			if is_reference_type (object_type) then
				get_object_fields (object_name, object_type)
					--elseif is_container_type (object_type) then
					--	get_container_sequence (object_name, object_type)
			end
		end

	get_container_sequence (object_name: STRING_32; object_type: TYPE_A)
			-- Obtain the initial state of a container
		do
				-- value of object_name.sequence
				-- print ("get the value of sequence of type: " + object_type.name + "%N")

		end

feature -- Properties checking

	is_aliased_with_existed_object (object_name: STRING_32): BOOLEAN
			-- Is the given object an alias with one of the instantiated objects?
		local
			object_value: STRING_32
		do
			object_value := ""
			object_value.copy (initial_values [object_name])
			Result := alias_groups.has (object_value) and not alias_groups [object_value] [1].same_string (object_name)
		end

	is_container_type (object_type: TYPE_A): BOOLEAN
			-- Is the given type a container type?
		local
			type: STRING_32
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

	is_abstract_value (value: STRING_32): BOOLEAN
			-- Is the `value' an abstract value?
		do
			Result := value.has_substring ("T@U")
		end

	is_basic_type (type: TYPE_A): BOOLEAN
			-- Is the given type a basic type?
		local
			type_name: STRING_32
		do
			Result := False
			if type.has_associated_class then
				type_name := type.base_class.name
				if type_name.same_string ("INTEGER") or type_name.same_string ("INTEGER_32") or
					type_name.same_string ("NATURAL") or type_name.same_string ("BOOLEAN") or
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

