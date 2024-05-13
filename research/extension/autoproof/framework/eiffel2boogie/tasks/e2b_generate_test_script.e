note
	description: "This class generates tests and writes them in the output file."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_GENERATE_TEST_SCRIPT

inherit
	INTERNAL_COMPILER_STRING_EXPORTER

	E2B_SHARED_CONTEXT

create
	make

feature -- Initialize

	make (test_file_name: STRING; a_init_states: LINKED_LIST [E2B_CE_STATE_OF_ROUTINE])
			-- Initialize data for test generation
		local
			class_name: STRING
			l_file_name: STRING
		do
			start_timer
			class_name := ""
			create alias_groups.make (0)
			create missing_values.make_empty
			create references_to_declare.make (0)
			create routine_names.make_empty

			l_file_name := test_file_name.split ('\').last
			script_class_name := l_file_name.substring (1, l_file_name.count - 2) -- "PROOF2TEST_TEST_SET"
			script_class_name.to_upper

			initial_states := a_init_states
			create test_file.make_create_read_write (test_file_name)
			generate_test_file

			print ("writing test script time: " + current_timer.out + "%N")
			stop_timer
		end

feature -- Files and data

	test_file: PLAIN_TEXT_FILE
			-- Output .e file that storeds all test cases

	initial_states: LINKED_LIST [E2B_CE_STATE_OF_ROUTINE]
			-- Mapping from class.routine to a set of counterexamples

	alias_groups: HASH_TABLE [ARRAY [STRING], STRING]
			-- Mapping from an abstract value (object) to a list of references

	references_to_declare: HASH_TABLE [STRING, STRING]
			-- Reference objects that need to be declared as local variables

	missing_values: ARRAY [STRING]
			-- A set of variables whose values are missing

	target_feature: E2B_FEATURE_I
			-- Feature to test

	target_class: E2B_CLASS_C
			-- Class of the target feature

	creation_procedure: E2B_FEATURE_I
			-- Creation procedure of the target class

	initial_state: E2B_CE_STATE_OF_ROUTINE
			-- Initial state from model

	script_class_name: STRING
			-- Class name of the test script

	routine_names: ARRAY [STRING]

feature -- Test generation

	generate_test_file
			-- Write the test cases to the output file
		local
			t, last_target_feature: STRING
			i: INTEGER
			creators_keys: ARRAY [INTEGER]
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.generate_test_file%N")
			t := ""; last_target_feature := ""
			create creators_keys.make_empty
			test_file.put_string (header)

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

				if last_target_feature.same_string (target_class.actual_type.name + "." + target_feature.feature_name_32.to_string_8) then -- test case for the same feature
					i := i + 1
				else
					i := 1
					last_target_feature.copy (target_class.actual_type.name + "." + target_feature.feature_name_32.to_string_8)
				end

				t := t + generate_test (i)
			end

			if attached target_class then
				test_file.put_string ("%Ttest_" + target_class.name + "%N%T%Tdo%N")
				across routine_names as rn loop
					test_file.put_string_32 ("%T%T%T" + rn + "%N")
				end
				test_file.put_string_32 ("%T%Tend%N%N")
			end

			test_file.put_string_32 (t)
			test_file.put_string ("end%N")
		end

	header: STRING
			-- Header of the test file
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.header%N")
			Result := "class " + script_class_name + "%N%Ninherit%N%TEQA_TEST_SET%N%N" + "feature -- Tests from failed proofs %N%N"
		end

	compute_alias
			-- Store the aliases into the same group
		local
			i: INTEGER
			name, value: STRING
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.compute_alias%N")
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

	generate_test (i: INTEGER): STRING
			-- Generate the ith test case for the target routine based on the counterexample model m
		local
			t, td, tc, ti: STRING
			argument_name: STRING
			class_name, routine_name: STRING
			j: INTEGER
			current_type, argument_type, result_type: E2B_TYPE_A
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.generate_test%N")
			references_to_declare.wipe_out
			argument_name := ""; Result := ""
			class_name := target_class.actual_type.name
			routine_name := target_feature.feature_name_32.to_string_8
			current_type := safe_type (target_class.actual_type.actual_type)

			compute_alias

			t := "%Ttest_" + class_name + "_" + routine_name + "_" + i.out + "%N"
			routine_names.force ("%Ttest_" + class_name + "_" + routine_name + "_" + i.out, routine_names.count)
				-- TODO: add header comements for each test routine
			references_to_declare.extend (current_type.name, "Current")
				-- td := declare_object ("Current", target_class.actual_type.actual_type)
			tc := create_object ("Current", current_type)
			ti := instantiate_object ("Current", current_type)

			if attached target_feature.arguments then
				from
					j := 1
				until
					j > target_feature.arguments.count
				loop
					argument_name := target_feature.arguments.item_name_32 (j).to_string_8
					argument_type := safe_type (create {E2B_TYPE_A}.make (target_feature.arguments.array_item (j - 1)))
					j := j + 1
					references_to_declare.extend (argument_type.name, argument_name)
						-- td := td + declare_object (argument_name, argument_type)
					tc := tc + create_object (argument_name, argument_type)
					ti := ti + instantiate_object (argument_name, argument_type)
				end
			end

			result_type := target_feature.type

			td := ""
			if not safe_type_name (result_type.name).same_string ("Void") then
				references_to_declare.extend (result_type.name, routine_name + "_result")
				across references_to_declare.current_keys as k loop
					td := td + declare_object (k, references_to_declare [k])
				end

				t := t + "%T%Tlocal %N" + td + "%T%Tdo%N" + tc + ti
				t := t + "%T%T%T" + routine_name + "_result := " + routine_call + "%N%T%Tend%N%N"
			else
				across references_to_declare.current_keys as k loop
					td := td + declare_object (k, references_to_declare [k])
				end

				t := t + "%T%Tlocal %N" + td + "%T%Tdo%N" + tc + ti
				t := t + "%T%T%T" + routine_call + "%N%T%Tend%N%N"
			end

			Result.copy (t)
		end

	declare_object (object_name: STRING; object_type: STRING): STRING
			-- Declaration of all object references
		do
			Result := "%T%T%T" + safe_object_name (object_name) + ": " + safe_type_name (object_type) + "%N"
		end

	creation_routine_call (object_type: E2B_TYPE_A): STRING
			-- The first creation procedure of `type'
		local
			t: STRING
			arg_type: E2B_TYPE_A
			i: INTEGER
			creators_keys: ARRAY [INTEGER]
			l_class: E2B_CLASS_C
			l_creation_procedure: E2B_FEATURE_I
		do
			t := ""; Result := ""
			l_class := object_type.base_class
			create creators_keys.make_empty

			if l_class.creators /= Void and then l_class.creators.count > 0 then -- the first creation procedure
				creators_keys.copy (l_class.creators.current_keys)
					-- creation_procedure := target_class.feature_of_name_id (target_class.creators[1].key)
				l_creation_procedure := l_class.feature_of_name_id (creators_keys [1])
			end

				-- creation_procedure := object_type.base_class.feature_of_name_id (creators_keys [1])

			if l_creation_procedure /= Void then
					-- print ("creation procedure: " + l_creation_procedure.feature_name_32.to_string_8 + "%N")
				t := t + "." + l_creation_procedure.feature_name_32.to_string_8

					-- a.make(0, 0)
					-- a.make(100, 10000)
				if l_creation_procedure.has_arguments then
					t := t + " ("
					from
						i := 1
					until
						i > l_creation_procedure.arguments.count
					loop -- Minimize each argument of the target feature
						arg_type := create {E2B_TYPE_A}.make (l_creation_procedure.arguments.array_item (i - 1))
						if arg_type.name.same_string ("INTEGER") or arg_type.name.same_string ("INTEGER_8") or arg_type.name.same_string ("INTEGER_16") or arg_type.name.same_string ("INTEGER_32") then
							t := t + "0"
						elseif arg_type.name.same_string ("BOOLEAN") then
							t := t + "False"
						else -- reference type
							t := t + "Void"
						end

						if i < l_creation_procedure.arguments.count then
							t := t + " , "
						end
						i := i + 1
					end

					t := t + ")"
				end
			end
			Result.copy (t)
		end

	create_object (object_name: STRING; object_type: E2B_TYPE_A): STRING
			-- Creation of all object references
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.create_object%N")
			Result := ""
			if not is_basic_type (object_type.name) and not is_aliased_with_existed_object (object_name) then
				if object_type.name.has_substring ("SIMPLE_ARRAY") then
					Result := "%T%T%Tcreate " + safe_object_name (object_name) + ".make_empty%N"
				elseif object_type.name.same_string ("V_ARRAY") or object_type.name.same_string ("V_ARRAY_INTEGER") then
					Result := "%T%T%Tcreate " + safe_object_name (object_name) + ".make(1, 0)%N"
						-- TODO: create clause for other container types
--				elseif object_type.name.same_string ("V_ARRAYED_LIST_INTEGER") then
--					Result := "%T%T%Tcreate " + safe_object_name (object_name) + ".default_create%N"
				else
					Result := "%T%T%Tcreate " + safe_object_name (object_name) + creation_routine_call (object_type) + "%N"
						-- TODO: to be finished, to include the default reference arguments
				end
			end
		end

	instantiate_object (object_name: STRING; object_type: E2B_TYPE_A): STRING
			-- Instantiate an object
		local
			t, class_name_: STRING
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.instantiate_object%N")
			t := ""; Result := ""; class_name_ := ""
			class_name_.copy (safe_type_name (object_type.name))

			if initial_state.initial_values.has (object_name) then -- value obtained in the counterexample model
				if is_basic_type (object_type.name) then
					t := t + assignment (object_name, initial_state.initial_values [object_name])
				else
					t := t + instantiate_object_reference (object_name, safe_type (object_type))

				end
			end

			Result.copy (t)
		end

	assignment (object_name: STRING; object_value: STRING): STRING
			-- Assignment clause for assigning the given value
		do
			Result := "%T%T%T" + safe_object_name (object_name) + " := " + object_value + "%N"
		end

	instantiate_object_reference (object_name: STRING; object_type: E2B_TYPE_A): STRING
			-- Initialize an object reference 'object_name' based on the given counterexample `m'
		local
			t, field_name, field_value: STRING
			i: INTEGER
			field_type: E2B_TYPE_A
		do
			t := ""; field_name := ""; field_value := ""; Result := ""
			if is_void (object_name) then
				t := t + assignment (object_name, "Void")
			elseif is_aliased_with_existed_object (object_name) then
				t := t + assignment (object_name, safe_object_name (alias_groups [initial_state.initial_values [object_name]] [1]))
			elseif is_container_type (object_type.actual_type.name) then
				t := t + instantiate_container_object (object_name, object_type)
			else
				from
					i := 1
				until
					i > object_type.base_class.skeleton.count
				loop
						-- object_type.base_class.skeleton [i]
					field_name := object_type.base_class.skeleton [i].attribute_name -- object.field

					field_type := safe_type (create {E2B_TYPE_A}.make (object_type.base_class.skeleton [i].type_i))
					if not is_ignored_field (field_name, field_type) then
						if is_basic_type (field_type.name) then
							t := t + instantiate_basic_field (object_name, field_name, field_type.actual_type.name, i)
						else -- reference field
							field_name := object_name + "." + field_name
							references_to_declare.extend (field_type.name, field_name)
							t := t + create_object (field_name, field_type)
							t := t + instantiate_object_reference (field_name, field_type)
							t := t + instantiate_reference_field (object_name, field_name.split ('.').last)
						end
					end
					i := i + 1
				end

			end

			Result.copy (t)
		end

	instantiate_basic_field (object_name: STRING; field_name: STRING; field_type: STRING; i: INTEGER): STRING
			-- Initialize an object field of basic type
		local
			name, value: STRING
		do
			name := object_name + "." + field_name
			value := ""
			if initial_state.initial_values.has (object_name + "." + safe_field_name (field_name)) then
				value := initial_state.initial_values [object_name + "." + safe_field_name (field_name)]
			else
				missing_values.force (object_name + "." + field_name, missing_values.count)
					-- TODO: the counterexample is partial
			end

			if value ~ "" then
				if safe_field_type (field_type).has_substring ("integer") or safe_field_type (field_type).has_substring ("real") or safe_field_type (field_type).has_substring ("natural") then
					value := "0" -- default value of INTEGER or REAL
				elseif safe_field_type (field_type).has_substring ("boolean") then
					value := "false" -- default value of INTEGER object
				elseif safe_field_type (field_type).has_substring ("character") then
					value := "a"
				end
			end

			Result := "%T%T%T{P_INTERNAL}.set_" + safe_field_type (field_type) + "_field_ (%"" + field_name + "%", " + safe_object_name (object_name) + ", " + value + ")%N"
				-- + ("%T%T%T%T-- " + safe_object_name (object_name) + "." + field_name + " = " + value + "%N")
		end

	instantiate_reference_field (object_name: STRING; field_name: STRING): STRING
			-- Initialize an object field of reference type
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.instantiate_reference_field%N")
			Result := "%T%T%T{P_INTERNAL}.set_reference_field_ (%"" + field_name + "%", " + safe_object_name (object_name) + ", " + safe_object_name (object_name) + "_" + field_name + ")%N"
		end

	routine_call: STRING
			-- Invoke the call with initialized objects
		local
			argument_name, t: STRING
			i: INTEGER
		do
			t := ""; Result := ""
			t := t + "current_object." + target_feature.feature_name_32.to_string_8

			if attached target_feature.arguments then
				if target_feature.arguments.count >= 1 then
					t := t + " ("

					from
						i := 1
					until
						i > target_feature.arguments.count
					loop -- Minimize each argument of the target feature
						argument_name := target_feature.arguments.item_name_32 (i).to_string_8
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

	force_item (object_name: STRING; object_type: STRING; item_value: STRING; i: INTEGER): STRING
			-- Use force procedure to add elements to the container
		local
			force_routine_name: STRING
		do
				-- print ("E2B_GENERATE_TEST_SCRIPT.force_item%N")
			if object_type.same_string ("V_ARRAY2_INTEGER") then
				force_routine_name := "flat_put"
			elseif object_type.same_string ("V_ARRAYED_LIST_INTEGER") then
				force_routine_name := "extend_at"
			else
				force_routine_name := "force"
			end
			Result := "%T%T%T" + safe_object_name (object_name) + "." + force_routine_name + " (" + safe_item_value (item_value, object_type) + ", " + i.out + ")%N"
		end

	instantiate_container_object (object_name: STRING; object_type: E2B_TYPE_A): STRING
			-- Instantiate an object of container type based on the given counterexample model `m'
		local
			t, value, item_value, new_item_value: STRING
			i: INTEGER
			type: STRING
			len_s: STRING
			len_i: INTEGER
			full_name: STRING
		do
			t := ""; Result := ""; item_value := "0"
			type := object_type.name

			full_name := object_name + ".sequence"

			value := initial_state.initial_values [full_name]

			len_s := initial_state.container_size_named (full_name)

			if type.has_substring ("V_ARRAY") or type.has_substring ("SIMPLE_ARRAY") then
				if not len_s.is_empty and then len_s /~ "0" then
					len_i := len_s.to_integer_32
					from
						i := 1
					until
						i > len_i
					loop
						new_item_value := initial_state.container_item_named (full_name, i.out)
						if not new_item_value.is_empty then
							item_value := new_item_value
						end
						t := t + force_item (object_name, type, item_value, i)
						i := i + 1
					end
				else
					t := t + "%T%T%T" + " -- No sequence for array " + object_name + " found in the counterexample. %N"
				end
				t := t + "%N"

					-- TODO: add support for other container type
					-- TODO: use the same value for the cases where the array should be sorted
			end

			Result.copy (t)
		end

feature -- Name conversion

	safe_field_name (name: STRING): STRING
		do
			if name.same_string ("index") then
				Result := "index_"
			else
				Result := name
			end
		end

	safe_field_type (field_type: STRING): STRING
			-- Return the safe type of a data field
		do
			field_type.to_lower
			Result := field_type
				-- if field_type.has ('_') then
				-- 	Result := field_type.split ('_').first
				-- end
		end

	safe_item_value (a_value: STRING; a_type: STRING): STRING
			-- Convert an abstract value into its default value
		do
			Result := ""
			Result.copy (a_value)

			if Result.has_substring ("T@U") or Result.same_string ("") then
				if a_type.has_substring ("INTEGER") then
					Result := "0"
				elseif a_type.has_substring ("BOOLEAN") then
					Result := "false"
				elseif a_type.has_substring ("CHARACTER") then
					Result := "a"
				else
					Result := "Void"
				end
			elseif Result.same_string ("0") and a_type.has_substring ("BOOLEAN") then
				Result.copy ("false")
					-- TODO: return different values based on the item type, BOOLEAN, CHARACTER, reference
			end
		end

	safe_object_name (object_name: STRING): STRING
			-- Convert the name of object
		do
			Result := ""
			Result.copy (object_name)
			if Result.same_string ("Current") then
				Result := "current_object"
			elseif Result.has_substring ("Current.") then
				Result.replace_substring_all ("Current.", "current_object.")
			end

			if Result.has_substring (".") then
				Result.replace_substring_all (".", "_")
			end
		end

	safe_type (object_type: E2B_TYPE_A): E2B_TYPE_A
			-- Return a concrete type from a generic type
		local
			l_class: E2B_CLASS_C
			des_classes: ARRAYED_LIST [E2B_CLASS_C]
		do
			l_class := object_type.base_class
			create des_classes.make (0)
			if l_class.is_deferred then

				if not target_class.is_deferred and then target_class.conform_to (l_class) then
					Result := target_class.actual_type.actual_type

				elseif attached l_class.direct_descendants as l_desc and then not l_desc.is_empty then
						-- Result := l_class.actual_type.actual_type
						-- get the first non-deferred class
						-- if target_class.conform_to (l_class) then -- use the target class as the descendant
						-- 	Result := target_class.actual_type
						-- else
						-- TODO: for a deferred class, choose the appropriate descendant class

					across l_class.direct_descendants as d loop
						if not d.is_deferred then
							Result := d.actual_type.actual_type
						end
					end

					if not attached Result then -- no effective class in the direct descendants
						across l_class.direct_descendants as d loop
							des_classes.force (d)
							from
							until
								attached Result or des_classes.is_empty
							loop
								if attached des_classes.first.direct_descendants as dd and then not dd.is_empty then
									across dd as dc loop
										if not dc.is_deferred then
											Result := dc.actual_type.actual_type
										else
											des_classes.extend (dc)
										end
									end
								end
								des_classes.remove_i_th (1)
							end
						end
					end
				end
			end
				-- end

			if not attached Result then
				Result := object_type
			end
		end

	safe_type_name (type: STRING): STRING
			-- Convert the name of container type
		local
			t, item_type: STRING
			tuple_field_types: LIST [STRING]
			i: INTEGER
		do
			t := ""; Result := ""; item_type := ""
				-- type := object_type.name
			if type.has_substring ("[G") then
				if type.has_substring ("V_ARRAY") then
						-- item_type.copy (type.split ('^') [2])
					t := t + "V_ARRAY [INTEGER]"
				elseif type.has_substring ("SIMPLE_ARRAY") then
						-- item_type.copy (type.split ('^') [2])
					t := t + "SIMPLE_ARRAY [INTEGER]"
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

			if t.has_substring ("[like") then
				t := t.split (' ').last
			end
			Result.copy (t)
		end

feature -- Properties checking

	is_void (object_name: STRING): BOOLEAN
			-- Is the value of the object void?
		do
			Result := False
			if initial_state.initial_values.has (object_name) then
				Result := initial_state.initial_values [object_name].same_string (initial_state.initial_values ["Void"])
			end
		end

	is_aliased_with_existed_object (object_name: STRING): BOOLEAN
			-- Is the given object an alias with one of the instantiated objects?
		local
			object_value: STRING
		do
			object_value := ""
			if initial_state.initial_values.has (object_name) then
				object_value.copy (initial_state.initial_values [object_name])
			end

			if alias_groups.has (object_value) and not alias_groups [object_value] [1].same_string (object_name) then
				Result := True
			else
				Result := False
			end

		end

	is_container_type (type: STRING): BOOLEAN
			-- Is the given type a container type?
		local
			l_type: STRING
		do
			if type.has_substring ("[like") then
				l_type := type.split (' ').last
			elseif type.has_substring ("[G") then -- Generic type
				l_type := type.split (' ').first
			else
				l_type := type
			end

			if l_type.same_string ("V_ARRAY") or l_type.same_string ("V_ARRAY_INTEGER") or l_type.same_string ("V_ARRAY2_INTEGER") or
				l_type.same_string ("SIMPLE_ARRAY [BOOLEAN]") or l_type.same_string ("SIMPLE_ARRAY [INTEGER]") or l_type.same_string ("SIMPLE_ARRAY [INTEGER_32]") or l_type.same_string ("V_SEQUENCE") or
				l_type.same_string ("V_ARRAYED_LIST_INTEGER") or
				l_type.same_string ("LIST") or l_type.same_string ("BAG") or
				l_type.same_string ("SET") or l_type.same_string ("MAP") or
				l_type.same_string ("RELATION") or l_type.same_string ("TABLE") or
				l_type.same_string ("INTERVAL") or l_type.same_string ("TUPLE")
			then
				Result := True
			else
				Result := False
			end
		end

	is_abstract_value (value: STRING): BOOLEAN
			-- Is the `value' an abstract value?
		do
			Result := value.has_substring ("T@U")
		end

	is_basic_type (type: STRING): BOOLEAN
			-- Is `type' a basic type?
		do
			if type.same_string ("INTEGER") or type.same_string ("INTEGER_32") or
				type.same_string ("NATURAL") or type.same_string ("NATURAL_32") or type.same_string ("NATURAL_64") or
				type.same_string ("BOOLEAN") or
				type.same_string ("CHARACTER") or type.same_string ("REAL") then
				Result := True
			else
				Result := False
			end
		end

	is_ignored_field (name: STRING; type: E2B_TYPE_A): BOOLEAN
		do
			Result := (type.name.same_string ("V_LINKABLE_INTEGER") and (name.same_string ("right"))) or -- `right' in V_LINKABLE_INTEGER
				(type.name.same_string ("V_DOUBLY_LINKABLE_INTEGER") and (name.same_string ("left") or name.same_string ("right"))) or
				name.last_index_of ('_', name.count) = name.count or -- ghost attributes
				type.name.has_substring ("MML_SEQUENCE") or
				type.name.has_substring ("MML_SET") or
				type.name.has_substring ("MML_BAG") or
				type.name.has_substring ("MML_INTERVAL") or
				type.name.has_substring ("MML_MAP") or
				type.name.has_substring ("MML_PAIR") or
				type.name.has_substring ("MML_RELATION")
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

