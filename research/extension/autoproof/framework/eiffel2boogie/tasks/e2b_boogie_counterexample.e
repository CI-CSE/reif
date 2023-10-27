note
	description: "This class parses the input .model file to collect information for test generation."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_BOOGIE_COUNTEREXAMPLE

inherit
	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (model: STRING_32)
			-- Initialization
		do
			start_timer
			create constants_values.make (0)
			create heap_values.make (0)
			create heap_function.make (0)
			create seq_item.make (0)
			create seq_lengths.make (0)
			create class_field_relations.make (0)
			create heap_values.make (0)
			create passed_blocks_values.make (0)
			create function_values.make (0)

			class_name := ""
			routine_name := ""

			line_index := 1
			model_lines := model.split ('%N')

			get_constants_values

			get_function_values

			from
			until
				end_of_model_file or not heap_function.is_empty
			loop
				get_heap_function
			end

			if model.has_substring("sequence") then -- TODO: replace this with a cheaper way to check the existence of sequence
				get_sequence_elements
				get_sequence_lengths
			end

			if not passed_blocks_values.is_empty then
				get_passed_blocks
			end

			get_routine_and_class_name
				-- print("parsing model time: " + current_timer.out + "%N")
			stop_timer
		end

feature -- Colleted data

	model_lines: LIST [STRING_32]
			-- Model in lines

	line_index: INTEGER
			-- The current line position

	routine_name: STRING
			-- Target routine

	class_name: STRING
			-- Target class

	constants_values: HASH_TABLE [STRING, STRING]
			-- Mapping from constants to values

	function_values: HASH_TABLE [STRING, STRING]
			-- Mapping from <Heap Current> to a function value -- TODO Li: support other types other than boolean and integer

	class_field_relations: HASH_TABLE [STRING, STRING]
			-- Mapping from class.field to an abstract value

	heap_function: HASH_TABLE [STRING, STRING]
			-- Interpretation of a function that represents the heap behavior: [heap state, object, field] -> value

	heap_values: HASH_TABLE [STRING, STRING]
			-- Mapping from heap state names to values

	passed_blocks_values: ARRAYED_LIST [STRING]
			-- List of symbolic values of passed blocks

	seq_item: HASH_TABLE [STRING, STRING]
			-- Sequences' elements

	seq_lengths: HASH_TABLE [STRING, STRING]
			-- Sequences's lengths


feature -- Parse model

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
					t := t + "V_ARRAY" + " [" + item_type + "]"
				elseif type.has_substring ("SIMPLE_ARRAY") then
					item_type.copy (type.split ('^') [2])
					t := t + "SIMPLE_ARRAY" + " [" + item_type + "]"
				elseif type.has_substring ("LIST") then
					item_type.copy (type.split ('^') [2])
					t := t + "LIST" + " [" + item_type + "]"
				elseif type.has_substring ("TUPLE") then
					tuple_field_types := type.split ('#')
					tuple_field_types [1].copy (tuple_field_types [1].split ('^').last)
					t := t + "TUPLE" + " ["

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

	safe_name (name: STRING): STRING
			-- Get a valid name
		local
			words: LIST [STRING]
		do
			if name.has_substring ("@@") then -- this is usually the form of arguments; get rid of the prefix and suffix to get the actual argument name
				words := name.split ('@')
				Result := words.at (words.count - 2)
					-- elseif name.same_string ("Current") then
					--	Result := "current_object"

			elseif name.has ('.') then
				Result := safe_type (name.split ('.').first) + "." + name.split ('.').last
			else
				Result := name
			end

		end

	get_constants_values
			-- Collect the values of constants in the model
		local
			name, value, line: STRING
			words: LIST [STRING]
		do
			line := ""; name := ""; value := "";

			from
				line_index := 1
			until
				end_of_model_file or else model_lines [line_index].has_substring ("{")
			loop
				line.copy (model_lines [line_index].to_string_8)

				if line.has_substring ("->") then
					words := line.split (' ')
					name.copy (safe_name (words [1]))

					value.copy (words [3])

					if words [3].has ('(') then
						value.append (words [4])
					end

					if name.has_substring (".") then -- in the form of class_name.field_name
						name.copy (safe_name (name))
						class_field_relations [name.twin] := ""
						class_field_relations [name.twin].copy (value.twin)
					elseif name.same_string ("Heap") or name.has_substring ("Heap@") then
						heap_values [name.twin] := ""
						heap_values [name.twin].copy (value.twin)
					elseif name.same_string ("passed_blocks") or name.has_substring ("passed_blocks@") then
						passed_blocks_values.force (value.twin)
					else
						constants_values [name.twin] := ""
						constants_values [name.twin].copy (value.twin)
					end
					-- print ("constant value: " + name + " -> " + value + "%N")
				end
				read_next_line
			end
		end


	get_function_values
			-- Collect the set of function mappings in the model
		local
			func_name, object_value, heap_value, line: STRING
			l_key, l_value: STRING
			words: LIST [STRING]
		do
			line := ""; func_name := ""; object_value := ""; heap_value := ""; l_key := ""; l_value := ""
			-- TODO Li: support multiple functions; support functions of classes other than target class

			from
			until
				end_of_model_file or (model_lines [line_index].has_substring ("fun.") and not model_lines [line_index].has_substring ("ANY"))
			loop
				read_next_line
			end

			-- function name, object, Heap state --> value	
			-- Get the function

			func_name := safe_name (model_lines[line_index].to_string_8.split (' ').first.split ('.').last)

			from
				read_next_line
			until
				end_of_model_file or else (model_lines [line_index].has_substring ("}")) or else (model_lines [line_index].has_substring ("else"))
			loop
				line.copy (model_lines [line_index].to_string_8)

				if line.has_substring ("->") then
					words := line.split (' ')
					heap_value.copy (words [3])
					object_value.copy (words[4])

					l_key.copy (func_name + " " + heap_value + " " + object_value)
					l_value.copy (words [6])

					if not function_values.has (l_key) then
						function_values.extend (l_value, l_key)
					else
						function_values [l_key] := l_value
					end

--					name.copy (safe_name (words [1]))

--					value.copy (words [3])

--					if words [3].has ('(') then
--						value.append (words [4])
--					end

				end
				read_next_line
			end
		end

	get_heap_function
			-- Construct a hash table for ``Select'' function
		local
			line, value: STRING
			words: LIST [STRING]
		do
				-- print ("E2B_BOOGIE_COUNTEREXAMPLE.get_heap_function%N")
			line := ""; value := ""
				-- Go to the head of the heap function
			from
			until
				end_of_model_file or (model_lines [line_index].has_substring ("MapType") and model_lines [line_index].has_substring ("Select"))
			loop
				read_next_line
			end

			from
				read_next_line
			until
				end_of_model_file or else model_lines [line_index].has_substring ("}")
			loop
				line.copy (model_lines [line_index].to_string_8)
				if is_heap_state_line (line) then
					words := line.split (' ')
					heap_function [words[3] + ", " + words [4] + ", " + words [5]] := ""
					value.copy (words [7])

					if words [7].has ('(') then
						value.append (words [8])
					end
					heap_function [words[3] + ", " + words [4] + ", " + words [5]].copy (value)
					-- TODO: make use of other info in the "Select" function
				end
				read_next_line
			end
			across heap_function.current_keys as k loop
				-- print (k + "->" + heap_function [k] + "%N")
			end
		end

	is_heap_state_line (a_line: STRING): BOOLEAN
		-- Does `a_line' contain the value of any heap state?
		do
			from
				heap_values.start
			until
				heap_values.after or Result
			loop
				if a_line.has_substring (heap_values.item_for_iteration) then
					Result := True
				end
				heap_values.forth
			end
		end

	get_sequence_elements
			-- Collect the elements of sequences
		local
			line, value, key: STRING
			words: LIST [STRING]
		do
			line := ""; value := ""; key := ""

			from
			until
				end_of_model_file or model_lines [line_index].has_substring ("Seq#Item")
			loop
				read_next_line
			end

			from
				read_next_line
			until
				end_of_model_file or else model_lines [line_index].has_substring ("}")
			loop
				line.copy (model_lines [line_index].to_string_8)

				words := line.split (' ')
				if words [3].same_string ("else") then
					key.copy ("else")
					value.copy (words [5])
					if value.has_substring ("(") then
						value.append (words [6])
					end

				elseif words.count >= 5 then
					key.copy (words [3] + ", " + words [4])
					if words [4].has ('(') then
						key.append (words [5])
						value.copy (words [7])
						if value.has_substring ("(") then
							value.append (words [8])
						end
					else
						value.copy (words [6])
						if value.has_substring ("(") then
							value.append (words [7])
						end
					end

				end

				if not key.has ('-') and not key.same_string ("0") then -- exclude pairs with non-positive indexes
					seq_item.extend (value.twin, key.twin)
				end
				read_next_line
			end
		end

	get_sequence_lengths
			-- Collect the lengths of sequences
		local
			line, value, key: STRING
			words: LIST [STRING]
		do
			line := ""; value := ""; key := ""
			seq_lengths.wipe_out

			from
			until
				end_of_model_file or else model_lines [line_index].has_substring ("Seq#Length")
			loop
				read_next_line
			end

			from
				read_next_line
			until
				end_of_model_file or else model_lines [line_index].has_substring ("}")
			loop
				line.copy (model_lines [line_index].to_string_8)
				if not line.has_substring ("else") then
					words := line.split (' ')
					if not seq_lengths.has (words [3]) then
						seq_lengths.extend (words [5], words [3])
					else
						seq_lengths [words [3]] := words [5].twin
					end

				end
				read_next_line
			end

		end

	get_passed_blocks
			-- Collect the ids of passed blocks from the function of Seq#Update
		local
			line, value: STRING
			words: LIST [STRING]
		do
			line := ""; value := "["

			passed_blocks_values.compare_objects

			from
			until
				end_of_model_file or else model_lines [line_index].has_substring ("Seq#Update")
			loop
				read_next_line
			end

			from
				read_next_line
			until
				end_of_model_file or else model_lines [line_index].has_substring ("}")
			loop
				line.copy (model_lines [line_index].to_string_8)
				if not line.has_substring ("else") then
					words := line.split (' ')
					if passed_blocks_values.has (words [3]) then
						value := value + words [4].out + ","
					end

				end
				read_next_line
			end

			value.remove_tail (1) -- remove the last comma
			value.extend (']')
			constants_values ["passed_blocks"] := ""
			constants_values ["passed_blocks"].copy (value)
		end

	read_next_line
			-- Increase the line index by 1
		do
			line_index := line_index + 1
		end

	end_of_model_file: BOOLEAN
			-- Is the end of the model file?
		do
			Result := (line_index >= model_lines.count)
		end

	get_routine_and_class_name
			-- Collect the name of the target routine and target class
		local
			line: STRING
		do
			line := ""
			from
			until
				end_of_model_file
			loop
				if model_lines [line_index].has_substring ("*** STATE") then
					line.copy (model_lines [line_index].to_string_8)
					class_name.copy (line.split (' ').last.split ('.').first)
					routine_name.copy (line.split (' ').last.split ('.').last)
				end
				read_next_line
			end
				-- print("class name: " + class_name + " " + "routine name: " + routine_name + "%N")

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

