note
	description: "Task to re-verify with inlining."

class
	E2B_VERIFY_FOR_FULL_MCDC_TESTS_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH
		export
			{NONE} all
		end

create
	make

feature {NONE} -- Initialization

	make (a_translator_input: E2B_TRANSLATOR_INPUT; a_initial_result_generator: attached like initial_result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			initial_result_generator := a_initial_result_generator
			remaining_tasks := a_tasks
			has_next_step := True
			l_translator_input := a_translator_input
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	sleep_time: NATURAL = 0
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		local

			l_boogie_universe: IV_UNIVERSE
		do
			create l_boogie_universe.make
			boogie_universe_cell.put (l_boogie_universe)
			helper.reset
			result_handlers.wipe_out

			create new_verifier.make
			create result_generator.make
			remaining_tasks.start
			remaining_tasks.forth -- Skip current task in queue

			remaining_tasks.put_left (create {E2B_TRANSLATE_CHUNK_TASK}.make (l_translator_input, l_boogie_universe))
			remaining_tasks.put_left (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, new_verifier))
			remaining_tasks.put_left (create {E2B_EXECUTE_BOOGIE_TASK}.make (new_verifier))
			remaining_tasks.put_left (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (new_verifier, initial_result_generator, remaining_tasks))
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

	compute_uncovered_branch
			-- Compute uncovered branches based on branch_log and branch_info
		local
			branch_set, covered_branch: HASH_TABLE [TUPLE [class_name: IMMUTABLE_STRING_32; line_number: INTEGER], INTEGER]
		do
			branch_set := read_branch_info ("branch_info.txt")
			covered_branch := read_branch_info ("\auto_test\log\branch_log.txt")

			-- Compute the uncovered branches by `branch_set' - `covered_branch'
			across branch_set.current_keys as k loop
				if not covered_branch.has (k) then
					options.uncovered_branch.extend (branch_set.at (k), k)
				end
			end

		end

feature {NONE} -- Implementation

	l_translator_input: E2B_TRANSLATOR_INPUT

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.

	initial_result_generator: attached E2B_RESULT_GENERATOR
			-- Boogie verifier.

	new_verifier: detachable E2B_VERIFIER
			-- Boogie verifier.

	result_generator: attached E2B_RESULT_GENERATOR
			-- Result generator.

	boogie_executable: E2B_PLATFORM_EXECUTABLE_IMPL

	read_branch_info (a_file: STRING): HASH_TABLE [TUPLE [class_name: IMMUTABLE_STRING_32; line_number: INTEGER], INTEGER]
		-- Read information of branches stored in the `a_file'
		-- The information is given in the form "Branch XXX Class XXX Line XXX"
	local
		l_branch_id, l_class_name, l_line_number: IMMUTABLE_STRING_32
		branch_info_file: PLAIN_TEXT_FILE
		words: LIST [STRING]
	do
		l_branch_id := ""; l_class_name := ""; l_line_number := ""
		create branch_info_file.make_open_read (system.eiffel_project.project_directory.path.extended (a_file).out)
		create Result.make (0)

		from
			branch_info_file.start
		until
			branch_info_file.end_of_file
		loop
			branch_info_file.read_line
			if not branch_info_file.last_string.is_empty then
				words := branch_info_file.last_string.split (' ')
				l_branch_id.copy (words [2])
				l_class_name.copy (words [4])
				l_line_number.copy (words [6])
				if not Result.has (l_branch_id.to_integer) then
					Result.extend ([create {IMMUTABLE_STRING_32}.make_from_string (l_class_name), l_line_number.to_integer], l_branch_id.to_integer)
				end
			end
		end
	end


	;

note
	date: "$Date: 2022-01-19 03:46:44 +0800 (Wed, 19 Jan 2022) $"
	revision: "$Revision: 106120 $"
	copyright:
		"Copyright (c) 2012-2014 ETH Zurich",
		"Copyright (c) 2018 Politecnico di Milano",
		"Copyright (c) 2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Alexander Kogtenkov"
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
