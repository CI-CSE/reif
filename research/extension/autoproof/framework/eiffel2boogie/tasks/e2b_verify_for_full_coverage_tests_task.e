note
	description: "Task to re-verify with inlining."

class
	E2B_VERIFY_FOR_FULL_COVERAGE_TESTS_TASK

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
			-- print ("E2B_VERIFY_FOR_FULL_COVERAGE_TESTS_TASK.make%N")
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
			-- <Precursor>120
		local

			l_boogie_universe: IV_UNIVERSE
			-- l_context: E2B_SHARED_CONTEXT
		do
			create l_boogie_universe.make
			boogie_universe_cell.put (l_boogie_universe)
			helper.reset
			result_handlers.wipe_out

			create new_verifier.make -- .make_with_prefix (options.target_class.name + "." + options.target_feature.feature_name_32.to_string_8) -- construct name of the boogie file
			create result_generator.make
			remaining_tasks.start
			remaining_tasks.forth -- Skip current taks in queue
				-- TODO: compute branch difference based on branch_info and branch_log
			-- compute_uncovered_branch
			remaining_tasks.put_left (create {E2B_TRANSLATE_CHUNK_TASK}.make (l_translator_input, l_boogie_universe))
			remaining_tasks.put_left (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, new_verifier))
			remaining_tasks.put_left (create {E2B_EXECUTE_BOOGIE_TASK}.make (new_verifier))
			remaining_tasks.put_left (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (new_verifier, initial_result_generator))

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
			branch_log_file, branch_info_file: PLAIN_TEXT_FILE
			branch_set: HASH_TABLE [TUPLE [class_name: IMMUTABLE_STRING_32; line_number: INTEGER], INTEGER]
				-- A collection of all branches; mappings from branch id to class name and line number
			covered_branch: HASH_TABLE [TUPLE [class_name: IMMUTABLE_STRING_32; line_number: INTEGER], INTEGER]
				-- A collection of branches covered in the test suite; mappings from branch id to class name and line number
			l_branch_id, l_class_name, l_line_number: IMMUTABLE_STRING_32
			words: LIST [STRING]
		do
			l_branch_id := ""; l_class_name := ""; l_line_number := ""

				-- 1) read branch_info file, retrive the information and store in branch_set
			create branch_info_file.make_open_read (system.eiffel_project.project_directory.path.extended ("branch_info.txt").out)
			create branch_set.make (0)
			from
				branch_info_file.start
			until
				branch_info_file.end_of_file
			loop
				branch_info_file.read_line
				-- print ("read branch_info at line: " + branch_info_file.last_string + "%N")
				if not branch_info_file.last_string.is_empty then
					words := branch_info_file.last_string.split (' ') -- Branch 27 Class ICSE24_CLOCK Line 90
					l_branch_id.copy (words [2])
					l_class_name.copy (words [4])
					l_line_number.copy (words [6])
					-- branch_set [l_branch_id.to_integer].class_name := ""
					-- branch_set [l_branch_id.to_integer].class_name.copy (l_class_name)
					-- branch_set [l_branch_id.to_integer].line_number := l_line_number.to_integer
					-- branch_set [l_branch_id.to_integer].
					branch_set.extend ([create {IMMUTABLE_STRING_32}.make_from_string (l_class_name), l_line_number.to_integer], l_branch_id.to_integer)
				end
			end

			print (" ========== all branches ========== %N")
			across branch_set.current_keys as k loop
				print (k.out + "->" + branch_set [k].class_name + ", " + branch_set [k].line_number.out + "%N")
			end
				-- model_lines := model.split ('%N')
				-- 2) read branch_log file, retrieve the information and store in covered_branch
			create branch_log_file.make_open_read (system.eiffel_project.project_directory.testing_results_path.extended ("\auto_test\log\branch_log.txt").out)
			create covered_branch.make (0)
			from
				branch_log_file.start
			until
				branch_log_file.end_of_file
			loop
				branch_log_file.read_line
				if not branch_log_file.last_string.is_empty then
					words := branch_log_file.last_string.split (' ') -- Branch 27 Class ICSE24_CLOCK Line 90
					l_branch_id.copy (words [2])
					l_class_name.copy (words [4])
					l_line_number.copy (words [6])
					if not covered_branch.has (l_branch_id.to_integer) then
						covered_branch.extend ([create {IMMUTABLE_STRING_32}.make_from_string (l_class_name), l_line_number.to_integer], l_branch_id.to_integer)
					end
				end
			end
			print (" ========== covered branches ========= %N")
			across covered_branch.current_keys as k loop
				print (k.out + "->" + covered_branch [k].class_name + ", " + covered_branch [k].line_number.out + "%N")
			end

				-- 3) compute the difference between branch_set and covered_branch
				-- create options.uncovered_branch.make (0)
			across branch_set.current_keys as k loop
				if not covered_branch.has (k) then
					options.uncovered_branch.extend (branch_set.at (k), k)
				end
			end
				-- handle the branches in IV_BOOGIE_PRINTER
			print ("========== uncovered branches ========== %N")
			across options.uncovered_branch.current_keys as k loop
				print (k.out + "->" + options.uncovered_branch [k].class_name + ", " + options.uncovered_branch [k].line_number.out + "%N")
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
