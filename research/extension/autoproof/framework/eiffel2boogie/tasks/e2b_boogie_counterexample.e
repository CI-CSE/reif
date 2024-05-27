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

feature

	parse_names (text: STRING): TUPLE [
			names: HASH_TABLE [STRING, STRING];
			consumed: INTEGER]
			-- Parses `x -> y` name values.
			-- Stops on first line which does not have this format.
			-- Returns:
			--   `names` — hash table of Name to Id
			--   `consumed` — how many characters were parsed
		local
			done: BOOLEAN
			line_length: INTEGER
			parts: LIST [STRING]
		do
			create Result
			Result.names := create {HASH_TABLE [STRING, STRING]}.make (10)

			across
				text.split ('%N') as line
			until
				done
			loop
				line_length := line.count + 1 -- Add 1 for %N from the split
				parts := explode_2 (line, " -> ")
				if parts.count = 2 and parts.last /~ "{" then
					Result.names.put (parts.last, parts.first)
					Result.consumed := Result.consumed + line_length
				else
					done := True
						-- don't increase Result.consumed because we did not consume this line
				end
			end
		ensure
			class
		end

	parse_functions (text: STRING): TUPLE [
			functions: HASH_TABLE [
			LIST [TUPLE [args: detachable LIST [STRING]; res: STRING]],
			STRING];
			consumed: INTEGER]
			-- Parse `x -> { y -> z }` lines of the .model file format
			-- Stops when line does not match the format.
			-- Result is a table from function name (`x`) to list of function cases.
			-- Last case has `args = Void`, this is the `else` case
			-- 	or (in case of `x -> y`) the constant value of the function.
		local
			name: STRING
			parts: LIST [STRING]
			in_cases: BOOLEAN
			case: TUPLE [args: detachable LIST [STRING]; res: STRING]
			cases: LINKED_LIST [TUPLE [args: detachable LIST [STRING]; res: STRING]]
			done: BOOLEAN
			line_length: INTEGER
		do
			create Result
			Result.functions := create {HASH_TABLE [
					LIST [TUPLE [args: detachable LIST [STRING]; res: STRING]],
					STRING]}
				.make (10)

			across
				text.split ('%N') as line
			until
				done
			loop
				line_length := line.count + 1 -- add 1 for %N from split
				line.adjust

				if not in_cases then
						-- Split `x -> y`
					parts := explode_2 (line, " -> ")
					if parts.count < 2 then
						done := True
					else
						name := parts [1]
						check parts [2] ~ "{" then end
						create cases.make
						in_cases := True
						Result.consumed := Result.consumed + line_length
					end
				else -- in_cases
					if line ~ "}" then
						in_cases := False
						Result.functions.put (cases, name)
						Result.consumed := Result.consumed + line_length
					else
							-- Split `x y z -> w`
						parts := explode_2 (line, " -> ")
						create case
						if parts [1] ~ "else" then
							case.args := Void
							case.res := parts [2]
						else
							case.args := parts [1].split (' ')
							case.res := parts [parts.count]
						end

						cases.extend (case)
						Result.consumed := Result.consumed + line_length
					end
				end
			end
		ensure
			class
		end

	parse_states (text: STRING): LIST [
		TUPLE [name: STRING; values: HASH_TABLE [STRING, STRING]]]
		local
			in_state: BOOLEAN
			done: BOOLEAN
			name: STRING
			values: HASH_TABLE [STRING, STRING]
			parts: LIST [STRING]
			tup: TUPLE [name: STRING; values: HASH_TABLE [STRING, STRING]]
		do
			create {LINKED_LIST [TUPLE [STRING, HASH_TABLE [STRING, STRING]]]}
				Result.make

			across
				text.split ('%N') as line
			until
				done
			loop
				line.adjust
				if in_state then
					if line ~ "*** END_STATE" then
						create tup
						tup.name := name
						tup.values := values
						Result.extend (tup)
						in_state := False
					else
						parts := explode_2 (line, " -> ")
						if parts.count > 1 and then not parts.last.is_empty then
							values [parts.first] := parts.last
						end
					end
				else
					if line.starts_with ("*** STATE ") then
						name := line.split (' ').last
						create values.make (0)
						in_state := True
					else
						check line ~ "*** END_MODEL" then end
						done := True
					end
				end
			end
		ensure
			class
		end

	explode_2 (s, by: STRING): LIST [STRING]
			-- Explode string `s` once by `by`
		local
			x: INTEGER
		do
			create {LINKED_LIST [STRING]} Result.make

			x := s.substring_index (by, 1)
			if x < 1 then
				Result.extend (s)
			else
				Result.extend (s.substring (1, x - 1))
				Result.extend (s.substring (x + by.count, s.count))
			end
		ensure
			class
		end

	skip_header (lines: STRING): INTEGER
		local
			line_length: INTEGER
			s: STRING
		do
			s := lines.split ('%N').first
			line_length := s.count + 1 -- 1 for %N from split
			s.adjust
			check s ~ "*** MODEL" then end
			Result := line_length
		ensure
			class
		end

feature {NONE} -- Initialization

	make (model_32: STRING_32)
			-- Initialization
		local
			index: INTEGER
			names_res: like parse_names
			functions_res: like parse_functions
			model: STRING
			header: STRING
		do
			start_timer

			check model_32.is_valid_as_string_8 then end
			model := model_32.to_string_8

			index := skip_header (model)
			header := "*** MODEL%N"
			check model.starts_with (header) then end
			index := header.count + 1

			names_res := parse_names (model.substring (index, model.count))
			index := index + names_res.consumed
			initial_name_to_raw := names_res.names

			functions_res := parse_functions (model.substring (index, model.count))
			index := index + functions_res.consumed
			functions := functions_res.functions

			states := parse_states (model.substring (index, model.count))

			stop_timer
		end

feature -- Colleted data

	initial_name_to_raw: HASH_TABLE [STRING, STRING]
			-- Raw value by a name.
			-- See also `parse_names`.

	functions: HASH_TABLE [
		LIST [TUPLE [args: detachable LIST [STRING]; res: STRING]],
		STRING]
			-- All functions from the model file
			-- see `parse_functions`

	states: LIST [TUPLE [name: STRING; values: HASH_TABLE [STRING, STRING]]]
			-- State clauses (`*** STATE`) in the same order as in the input file.
			-- Entries with empty values (`x -> `) are not present in `values`.
			-- See also `parse_states`.

	apply_function (name: STRING; args: detachable LIST [STRING]): STRING
			-- Return raw result of function by raw `args`.
			-- Void `args` is accepted.
		local
			cases: like functions.item
		do
			cases := functions [name]
			across cases as c until Result /= Void loop
				if args = Void then
					if c.args = Void then
						Result := c.res
					end
				else
					if c.args.count = args.count
						and then ∀ i: 1 |..| c.args.count ¦ c.args [i] ~ args [i] then
						Result := c.res
					end
				end
			end
			if Result = Void then
				-- Last case is "else"
				check cases.last.args = Void then end
				Result := cases.last.res
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

