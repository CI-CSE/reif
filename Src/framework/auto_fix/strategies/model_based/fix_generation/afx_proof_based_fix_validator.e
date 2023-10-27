note
	description: "Summary description for {AFX_FIX_VALIDATOR_NEW}."
	author: ""
	date: "$Date: 2014-06-27 20:57:49 +0800 (Fri, 27 Jun 2014) $"
	revision: "$Revision: 95332 $"

class
	AFX_PROOF_BASED_FIX_VALIDATOR

inherit
	EPA_DEBUGGER_UTILITY

	SHARED_DEBUGGER_MANAGER

	AFX_INTERPRETER_CONSTANTS

	EPA_COMPILATION_UTILITY

	AFX_UTILITY

	AFX_SHARED_PROJECT_ROOT_INFO

	AFX_SHARED_SESSION

create
	make

feature{NONE} -- Initialization

	make (a_trace_repository: AFX_CE_TRACE_REPOSITORY; a_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT])
			-- Initialize Current to validate fix candidates `a_fixes'.
		do
			-- the trace is not used?
			fixes := a_fixes.twin
			create valid_fixes.make_equal (fixes.count)
		end

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- Fix candidates to validate

	valid_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- List of valid fixed found so far

	context_class: CLASS_C
			-- Class under fix

feature -- Basic operation

	validate
			-- Validate `fixes'.
		local
			l_instrumentor: AFX_FIX_INSTRUMENTOR
		do
			if not fixes.is_empty then
				create l_instrumentor.make (fixes)
				l_instrumentor.instrument
				compile_project (eiffel_project, True)

				from until
					fixes.is_empty or else should_quit or else not session.should_continue
				loop
					validate_left_fixes
					should_quit := True
				end

				-- TODO Li: recover l_instrumentor.uninstrument
				-- compile_project (eiffel_project, True)
			end
		end

feature{NONE} -- Actions

	on_fix_validation_start (a_fix: AFX_CODE_FIX_TO_FAULT)
			-- Action to be performed when `a_melted_fix' is about to be validated
		do
			event_actions.notify_on_one_implementation_fix_validation_started (a_fix)
		end

	on_fix_validation_end (a_fix: AFX_CODE_FIX_TO_FAULT; a_exception_count: NATURAL_32)
			-- Action to be performed when `a_fix' has been validated.
		local
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_valid: BOOLEAN
			l_fix_text: STRING
			l_passing_count: INTEGER
			l_failing_count: INTEGER
			l_valid_fixes_count: INTEGER
		do
			l_valid := exception_count = a_exception_count
			if l_valid then
				a_fix.set_valid (True)
				valid_fixes.force_last (a_fix)

				if config.max_valid_fix_number > 0 and then config.max_valid_fix_number.to_integer_32 <= valid_fixes.count then
					worker.set_should_quit (True)
					should_quit := True
				end
			end
			event_actions.notify_on_one_implementation_fix_validation_finished (a_fix)
			exception_count := a_exception_count
		end

	on_proof_execution_time_out
			-- Action to be performed when test case execution timed out
		do
			worker.set_is_execution_over_time (True)
			event_actions.notify_on_test_case_execution_time_out
			check process /= Void end
			process.terminate_tree
			process.wait_for_exit
		end

feature{NONE} -- Inter-process communication attributes

	process: PROCESS
		-- Process for the interpreter

	worker: AFX_FIX_VALIDATION_THREAD_NEW
			-- Worker thread to validate fix candidates

	port: INTEGER
			-- Port used by `socket'

	should_quit: BOOLEAN
			-- Should fix validation be stopped?

	exception_count: NATURAL_32
			-- Number of exceptions that are encountered so far

feature{NONE} -- Implementation

	validate_left_fixes
			-- Validate fixes in `melted_fixes'.
		local
			l_fac: PROCESS_FACTORY
			l_cmd_line: STRING
			l_timer: AFX_TIMER_THREAD
		do
			if not fixes.is_empty then
				exception_count := 0
				create l_fac
				-- l_cmd_line := system.eiffel_system.application_name (True).out + " --validate-fix " + session.interpreter_log_path.utf_8_name + " true " + port.out + " -eif_root " + afx_project_root_class + "." + afx_project_root_feature
				l_cmd_line := command_line_for_validate_fixes

				process := l_fac.process_launcher_with_command_line (l_cmd_line, session.working_directory.utf_8_name)
				process.launch	-- Launch AutoProof to check validity

				check process.launched end
						create l_timer.make (agent on_proof_execution_time_out)
						l_timer.reset_timer
						-- create worker.make (fixes, agent on_fix_validation_start, agent on_fix_validation_end, l_timer, socket, test_cases)
						-- worker.execute
						process.wait_for_exit_with_timeout (10000000)
						if not process.has_exited then
							process.terminate_tree
							process.wait_for_exit
						end
					-- end
				-- else
				--	event_actions.notify_on_interpreter_failed_to_start (port)
--					if process /= Void and then process.launched and then not not process.has_exited then
--						process.terminate_tree
--						process.wait_for_exit
--					end
				-- end
			end
		end

	store_string_in_file (a_directory: PATH; a_file_name: STRING; a_content: STRING)
			-- Create a file named `a_file_name' in `a_directory' and store `a_content' in it.
		local
			l_path: FILE_NAME
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_with_path (a_directory.extended (a_file_name))
			l_file.create_read_write
			l_file.put_string (a_content)
			l_file.close
		end

	command_line_for_validate_fixes: STRING
			-- Command line string for testing `a_classes'.
		-- require
			-- a_classes /= Void and then not a_classes.is_empty
		local
			l_seed: STRING
			l_cursor: DS_HASH_SET_CURSOR [CLASS_C]
			l_class: CLASS_C
		do
			l_class := fixes.first.fixing_target.context_class.twin
			create Result.make_empty
			Result := "%"" + session.eve_path.out + "%" "
					+ "-project_path %"" + session.project_path_in_working_directory.out + "%" "
					+ "-config %"" + session.ecf_path_in_working_directory.out + "%" "
					+ "-target " + session.target_of_project + " "
					--+ "-auto_test -i -f --agents none --integer-bounds -512,512 --state argumentless --serialization passing,failing --retrieve-serialization-online "
					+ "-autoproof" + " -validate_fix " -- + " -contract_inference"-- -i -f --agents none --integer-bounds -512,512 --state argumentless --serialization passing,failing --retrieve-serialization-online "
					-- + "-t " + config.max_session_length_for_testing.out + " "
					-- -timeout " + config.max_session_length_for_proof.out + "
					-- + l_seed + " "
					-- + "--output-test-case-online %"" + config.working_directory.testing_result_dir.out + "%" ";
			Result.append (" " + l_class.name)

-- TODO Li: support multiple classes
--			from
--				l_cursor := a_classes.new_cursor
--				l_cursor.start
--			until
--				l_cursor.after
--			loop
--				Result.append (" " + l_cursor.item.name_in_upper)
--				l_cursor.forth
--			end
		end

end


