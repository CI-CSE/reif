note
	description: "[
		Interface to run the Boogie verifier.
		
		Usage:
			create verifier.make
			verifier.input.add_boogie_file ("file.bpl")
			verifier.input.add_custom_content ("some boogie code")
			verifier.verify
			verifier.parse_verification_output
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_VERIFIER

inherit

	E2B_SHARED_CONTEXT
	SHARED_WORKBENCH

create
	make, make_with_prefix

feature {NONE} -- Initialization

	make
			-- Initialize Boogie verifier.
		do
			index := unique_number
			create {E2B_PLATFORM_EXECUTABLE_IMPL} executable.make (index)
			create input.make
		end

	make_with_prefix (file_prefix: STRING)
			-- Initialize Boogie verifier with specified Boogie file name and model file name.
		do
			create {E2B_PLATFORM_EXECUTABLE_IMPL} executable.make_with_prefix (file_prefix)
			create input.make
		end

feature -- Access

	index: INTEGER
			-- Index of verification run

	input: E2B_VERIFIER_INPUT
			-- Input for verifier.

	last_result: detachable E2B_BOOGIE_RESULT
			-- Result of last run of Boogie.
		do
			if not attached internal_last_result and then attached last_output then
				parse_verification_output
			end
			Result := internal_last_result
		end

	last_output: detachable STRING
			-- Output of last run of Boogie.
		do
			Result := executable.last_output
		end

	last_models: detachable STRING
			-- Countereamples (if any) of last run of Boogie.
		do
			Result := executable.last_models
		end

feature -- Status report

	is_running: BOOLEAN
			-- Is Boogie verifier running right now?
		do
			Result := executable.is_running
		end

feature -- Element change

	unique_number: INTEGER
		do
			Result := global_counter.item
			global_counter.put (Result + 1)
		end

	global_counter: CELL [INTEGER]
		once
			create Result.put (0)
		end

	set_input (a_input: like input)
			-- Set `input' to `a_input'.
		require
			a_input_attached: attached a_input
		do
			input := a_input
		ensure
			input_set: input = a_input
		end

feature -- Basic operations

	verify
			-- Launch Boogie verifier on input.
		do
			internal_last_result := Void
			executable.set_input (input)
			executable.run
		end

	verify_asynchronous
			-- Launch Boogie verifier on input, without waiting for Boogie to finish.
		do
			internal_last_result := Void
			executable.set_input (input)
			executable.run_asynchronous
		end

	verify_with_random_seed (a_random_seed: INTEGER)
			-- Launch Boogie verifier on input, without waiting for Boogie to finish.
		do
			internal_last_result := Void
			executable.set_input (input)
			executable.run_with_random_seed (a_random_seed)
		end

	cancel
			-- Cancel execution of Boogie.
		do
			executable.cancel
		end

	parse_verification_output
			-- Parse `last_output' and fill `last_result'.
		require
			last_output_set: attached last_output
		local
			l_boogie_parser: E2B_BOOGIE_OUTPUT_PARSER
		do
			create l_boogie_parser.make
			l_boogie_parser.parse (last_output, last_models)
			internal_last_result := l_boogie_parser.last_result

		ensure
			last_result_set: attached last_result
		end

feature {NONE} -- Implementation

	executable: attached E2B_EXECUTABLE
			-- Boogie executable.

	internal_last_result: detachable E2B_BOOGIE_RESULT
			-- Cached last result.

;

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
