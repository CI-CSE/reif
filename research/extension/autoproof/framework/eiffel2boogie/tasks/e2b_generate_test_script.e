note
	description: "This class generates tests and writes them in the output file."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_GENERATE_TEST_SCRIPT

inherit
	INTERNAL_COMPILER_STRING_EXPORTER

create
	make

feature -- Initialize

	make (test_file_name: STRING_32; a_init_states: LINKED_LIST [E2B_INITIAL_STATE_OF_ROUTINE])
			-- Initialize data for test generation
		local
			class_name: STRING_32
		do
			class_name := ""
			create alias_groups.make (0)
			create missing_values.make_empty
			create sequence_items.make (0)
			create sequence_lengths.make (0)

			script_class_name := "PROOF2TEST_TEST_SET"

			initial_states := a_init_states
			create test_file.make_create_read_write (test_file_name)
			generate_test_file
		end

feature -- Files and data

	test_file: PLAIN_TEXT_FILE
			-- Output .e file that storeds all test cases

	initial_states: LINKED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]
			-- Mapping from class.routine to a set of counterexamples

	alias_groups: HASH_TABLE [ARRAY [IMMUTABLE_STRING_32], IMMUTABLE_STRING_32]
			-- Mapping from an abstract value (object) to a list of references

	missing_values: ARRAY [IMMUTABLE_STRING_32]
			-- A set of variables whose values are missing

	sequence_items: HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
			-- Sequences' elements

	sequence_lengths: HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
			-- Sequences's lengths

	target_feature: FEATURE_I
			-- Feature to test

	target_class: CLASS_C
			-- Class of the target feature

	creation_procedure: FEATURE_I
			-- Creation procedure of the target class

	initial_state: E2B_INITIAL_STATE_OF_ROUTINE
			-- Initial state from model

	script_class_name: STRING_32
			-- Class name of the test script

feature -- Test generation

	generate_test_file
			-- Write the test cases to the output file
		local
			t, last_target_feature: STRING_32
			i: INTEGER
			creators_keys: ARRAY [INTEGER]
		do
			t := ""; last_target_feature := ""
			create creators_keys.make_empty
			test_file.put_string (header.to_string_8)

			across initial_states as s loop
				initial_state := s
				target_feature := s.target_feature
				target_class := s.target_class
					-- if r.creation_procedures.count > 0 then
					--    creation_procedure := r.creation_procedures.first
					-- end

				if target_class.creators /= Void and then target_class.creators.count > 0 then -- the first creation procedure
					creators_keys.copy (target_class.creators.current_keys)
						-- creation_procedure := target_class.feature_of_name_id (target_class.creators[1].key)
					creation_procedure := target_class.feature_of_name_id (creators_keys [1])
				end

				if last_target_feature.same_string (target_class.actual_type.name.to_string_8 + "." + target_feature.feature_name_32.to_string_8) then -- test case for the same feature
					i := i + 1
				else
					i := 1
					last_target_feature.copy (target_class.actual_type.name.to_string_8 + "." + target_feature.feature_name_32.to_string_8)
				end

				t := t + generate_test (i)
			end

			test_file.put_string_32 (t)
			test_file.put_string ("end%N")
		end

	header: STRING_32
			-- Header of the test file
		do
			Result := "class " + script_class_name.to_string_8 + "%N%Ninherit%N%TEQA_TEST_SET%N%N" + "feature -- Tests from failed proofs %N%N"
		end

	compute_alias
			-- Store the aliases into the same group
		local
			i: INTEGER
			name, value: STRING_32
		do
			alias_groups.make (0)

			from
				i := 1
			until
				i > initial_state.initial_values.count
			loop
				name := initial_state.initial_values.current_keys [i]
				value := initial_state.initial_values [name]

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
				i := i + 1
			end
		end

	generate_test (i: INTEGER): STRING_32
			-- Generate the ith test case for the target routine based on the counterexample model m
		local
			t, td, tc, ti: STRING_32
			argument_name: STRING_32
			class_name, routine_name: STRING_32
			j: INTEGER
			argument_type, result_type: TYPE_A
		do
			argument_name := ""; Result := ""
			class_name := target_class.actual_type.name
			routine_name := target_feature.feature_name_32

			compute_alias
			sequence_items := initial_state.ce.seq_item
			sequence_lengths := initial_state.ce.seq_lengths

			t := "%Ttest_" + class_name.to_string_8 + "_" + routine_name.to_string_8 + "_" + i.out + "%N"
				-- TODO: add header comements for each test routine

			td := declare_object ("Current", target_class.actual_type.actual_type)
			tc := create_object ("Current", target_class.actual_type.actual_type)
			ti := instantiate_object ("Current", target_class.actual_type.actual_type)

			if attached target_feature.arguments then
				from
					j := 1
				until
					j > target_feature.arguments.count
				loop
					argument_name := target_feature.arguments.item_name_32 (j)
					argument_type := target_feature.arguments.array_item (j - 1)
					j := j + 1
					print (argument_name + ": " + argument_type.actual_type.name + "%N")

					td := td + declare_object (argument_name, argument_type)
					tc := tc + create_object (argument_name, argument_type)
					ti := ti + instantiate_object (argument_name, argument_type)
				end
			end

			result_type := target_feature.type

				-- if is_container_type (result_type) then
				--	result_type.copy (safe_type (result_type))
				--end

			if not safe_type (result_type).same_string ("Void") then
				td := td + declare_object (routine_name + "_result", result_type)
				t := t + "%T%Tlocal %N" + td + "%T%Tdo%N" + tc + ti
				t := t + "%T%T%T" + routine_name + "_result := " + routine_call + "%N%T%Tend%N%N"
			else
				t := t + "%T%Tlocal %N" + td + "%T%Tdo%N" + tc + ti
				t := t + "%T%T%T" + routine_call + "%N%T%Tend%N%N"
			end

			Result.copy (t)
		end

	declare_object (object_name: STRING_32; object_type: TYPE_A): STRING_32
			-- Declaration of all object references
		do
			Result := "%T%T%T" + safe_object_name (object_name).to_string_8 + ": " + safe_type (object_type).to_string_8 + "%N"
		end

	creation_routine_call (object_type: TYPE_A): STRING_32
			-- The first creation procedure of `type'
		local
			t, arg_type: STRING_32
			i: INTEGER
		do
			t := ""; Result := ""

			if creation_procedure /= Void then
				print ("creation procedure: " + creation_procedure.feature_name_32.to_string_8 + "%N")
				t := t + "." + creation_procedure.feature_name_32.to_string_8

					-- a.make(0, 0)
					-- a.make(100, 10000)
				if target_feature.has_arguments then
					t := t + "("
					from
						i := 1
					until
						i > target_feature.arguments.count
					loop -- Minimize each argument of the target feature
						arg_type := target_feature.arguments.array_item (i - 1).name
						if arg_type.same_string ("INTEGER") then
							t := t + "0"
						elseif arg_type.same_string ("BOOLEAN") then
							t := t + "False"
						end

						if i < target_feature.arguments.count then
							t := t + " , "
						end
						i := i + 1
					end

					t := t + ")"
				end
			end
			Result.copy (t)
		end

	create_object (object_name: STRING_32; object_type: TYPE_A): STRING_32
			-- Creation of all object references
		do
			Result := ""

			if not is_basic_type (object_type) and not is_aliased_with_existed_object (object_name) then
				if object_type.name.has_substring ("SIMPLE_ARRAY") then
					Result := "%T%T%Tcreate " + safe_object_name (object_name).to_string_8 + ".make_empty%N"
				elseif object_type.name.has_substring ("V_ARRAY") then
					Result := "%T%T%Tcreate " + safe_object_name (object_name).to_string_8 + ".make(1, 0)%N"
						-- TODO: create clause for other container types
				else
					Result := "%T%T%Tcreate " + safe_object_name (object_name).to_string_8 + creation_routine_call (object_type).to_string_8 + "%N"
				end

			end
		end

	instantiate_object (object_name: STRING_32; object_type: TYPE_A): STRING_32
			-- Instantiate an object
		local
			t, class_name_: STRING_32
		do
			t := ""; Result := ""; class_name_ := ""
			class_name_.copy (safe_type (object_type))

			if initial_state.initial_values.has (object_name) then -- value obtained in the counterexample model
				if is_basic_type (object_type) then
					t := t + assignment (object_name, initial_state.initial_values [object_name])
				else
					t := t + instantiate_object_reference (object_name, object_type)

				end
			end

			Result.copy (t)
		end

	assignment (object_name: STRING_32; object_value: STRING_32): STRING_32
			-- Assignment clause for assigning the given value
		do
			Result := "%T%T%T" + safe_object_name (object_name).to_string_8 + " := " + object_value.to_string_8 + "%N"
		end

	instantiate_object_reference (object_name: STRING_32; object_type: TYPE_A): STRING_32
			-- Initialize an object reference 'object_name' based on the given counterexample `m'
		local
			t, field_name, field_value: STRING_32
			i: INTEGER
			field_type: TYPE_A
		do
			t := ""; field_name := ""; field_value := ""; Result := ""

			if is_aliased_with_existed_object (object_name) then
				t := t + assignment (object_name, safe_object_name (alias_groups [initial_state.initial_values [object_name]] [1]))
			elseif is_container_type (object_type.actual_type.name) then
				t := t + instantiate_container_object (object_name, object_type)
			else

				from
					i := 1
				until
					i > object_type.base_class.skeleton.count
				loop
					field_name := object_type.base_class.skeleton [i].attribute_name -- object.field
					field_type := object_type.base_class.skeleton [i].type_i
					field_value.copy (initial_state.initial_values [object_name + "." + field_name])

					if is_basic_type (field_type) then
						t := t + instantiate_basic_field (object_name, field_name, field_type.actual_type.name, field_value, i)
					else
						t := t + instantiate_object_reference (object_name + "." + field_name, field_type)
					end
					i := i + 1
				end

			end

			Result.copy (t)
		end

	instantiate_basic_field (object_name: STRING_32; field_name: STRING_32; field_type: STRING_32; field_value: STRING_32; i: INTEGER): STRING_32
			-- Initialize an object field of basic type
		local
			name, value: STRING_32
		do
			name := object_name + "." + field_name
			value := ""
			if initial_state.initial_values.has (name) then
				value := initial_state.initial_values [name]
				print(safe_field_type (field_type).to_string_8 + "--" + name.to_string_8 + ":" + value.to_string_8 + "%N")
			else
				missing_values.force (object_name + "." + field_name, missing_values.count)
					-- TODO: the counterexample is partial
			end

			if value ~ "" then
				if safe_field_type (field_type).has_substring ("integer") or safe_field_type (field_type).has_substring ("real") then
					value := "0"  -- default value of INTEGER or REAL
				elseif safe_field_type (field_type).has_substring ("boolean") then
					value := "false"  -- default value of INTEGER object
				elseif safe_field_type (field_type).has_substring ("character") then
					value := "a"
				end
			end

			Result := "%T%T%T{P_INTERNAL}.set_" + safe_field_type (field_type).to_string_8 + "_field_ (%"" + field_name.to_string_8 + "%", " + safe_object_name (object_name).to_string_8 + ", " + value.to_string_8 + ")%N"
				-- + ("%T%T%T%T-- " + safe_object_name (object_name).to_string_8 + "." + field_name.to_string_8 + " = " + value.to_string_8 + "%N")

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

	routine_call: STRING_32
			-- Invoke the call with initialized objects
		local
			argument_name, t: STRING_32
			i: INTEGER
		do
			t := ""; Result := ""
			t := t + "current_object." + target_feature.feature_name_32

			if attached target_feature.arguments then
				if target_feature.arguments.count >= 1 then
					t := t + " ("

					from
						i := 1
					until
						i > target_feature.arguments.count
					loop -- Minimize each argument of the target feature
						argument_name := target_feature.arguments.item_name_32 (i)
						t := t + argument_name
						if i < target_feature.arguments.count then
							t := t + ", "
						end
						i := i + 1
					end
					t := t + ")"
				end
			end

			Result.copy (t)
		end

	force_item (object_name: STRING_32; item_value: STRING_32; i: INTEGER): STRING_32
			-- Use force procedure to add elements to the container
		do
			Result := "%T%T%T" + object_name.to_string_8 + ".force(" + item_value.to_string_8 + ", " + i.out + ")%N"
		end

	instantiate_container_object (object_name: STRING_32; object_type: TYPE_A): STRING_32
			-- Instantiate an object of container type based on the given counterexample model `m'
		local
			t, value, item_value: STRING_32
			i: INTEGER
			type: STRING_32
		do
			t := ""; Result := ""; item_value := "0"
			type := object_type.actual_type.name

			value := initial_state.initial_values [object_name + ".sequence"]

			if type.has_substring ("V_ARRAY") or type.has_substring ("SIMPLE_ARRAY") then
					-- TODO: add support for other container type

				if sequence_lengths.has (value) and sequence_items.count > 0 then

					from
						i := 1
					until
						i > sequence_lengths [value].to_integer_32
					loop
						if sequence_items.has (value + ", " + i.out) then
							item_value := sequence_items [value + ", " + i.out]
						end

						t := t + force_item (object_name, item_value, i)
						i := i + 1
					end
				else
					t := t + " -- No sequence for array " + object_name + "found in the model. %N"
				end

				t := t + "%N"
			end

			Result.copy (t)
		end

	safe_object_name (object_name: STRING_32): STRING_32
			-- Convert the name of object
		do
			if object_name.same_string ("Current") then
				Result := "current_object"
			else
				Result := object_name
			end
		end

	safe_type (object_type: TYPE_A): STRING_32
			-- Convert the name of container type
		local
			t, item_type, type: STRING_32
			tuple_field_types: LIST [STRING_32]
			i: INTEGER
		do
			t := ""; Result := ""; item_type := ""
			type := object_type.name

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

feature -- Properties checking

	is_aliased_with_existed_object (object_name: STRING_32): BOOLEAN
			-- Is the given object an alias with one of the instantiated objects?
		local
			object_value: STRING_32
		do
			object_value := ""
			print ("check alias of: " + object_name.to_string_8 + "%N")
			object_value.copy (initial_state.initial_values [object_name])

			if alias_groups.has (object_value) and not alias_groups [object_value] [1].same_string (object_name) then
				Result := True
			else
				Result := False
			end
		end

	is_container_type (type: STRING_32): BOOLEAN
			-- Is the given type a container type?
		do
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
			-- Is `type' a basic type?
		local
			type_name: STRING_32
		do
			type_name := type.name
			if type_name.same_string ("INTEGER") or type_name.same_string ("INTEGER_32") or
				type_name.same_string ("NATURAL") or type_name.same_string ("BOOLEAN") or
				type_name.same_string ("CHARACTER") or type_name.same_string ("REAL") then
				Result := True
			else
				Result := False
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

