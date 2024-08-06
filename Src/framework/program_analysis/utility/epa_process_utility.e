note
	description: "[
		Utilities for process library, for example, process launching, result retrieval

		Based on `PROCESS_HELPER` from `Src/library/process/process_helper.e`.
	]"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_PROCESS_UTILITY

feature

	output_from_program (a_command: STRING; a_working_directory: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
		do
			Result := output_from_program_with_input_file_and_time_limit (a_command, a_working_directory, Void, 0)
		end

	output_from_program_with_input_file (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory'.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
		do
			Result := output_from_program_with_input_file_and_time_limit (a_command, a_working_directory, a_input_file, 0)
		end

	output_from_program_with_input_file_and_time_limit (a_command: STRING; a_working_directory: detachable STRING; a_input_file: detachable STRING; a_time_limit: INTEGER): STRING
			-- Output from the execution of `a_command' in (possibly) `a_working_directory', with time limit.
			-- Note: You may need to prune the final new line character.
			-- If `a_input_file' is attached, redirect input to that file.
			-- Returns empty string if the execution could not finish within time limit.
		require
			time_limit_big_enough: a_time_limit >= 0
		local
			l_prc_factory: BASE_PROCESS_FACTORY
			l_prc: BASE_PROCESS

			tmp_file: PLAIN_TEXT_FILE
		do
			create l_prc_factory
			l_prc := l_prc_factory.process_launcher_with_command_line (a_command, a_working_directory)
			l_prc.set_detached_console (False)
			l_prc.set_hidden (True)

			create tmp_file.make_open_temporary
			l_prc.redirect_output_to_file (tmp_file.path.name)

			if a_input_file /= Void then
				l_prc.redirect_input_to_file (a_input_file)
			end
			l_prc.launch
			if l_prc.launched then
				if a_time_limit > 0 then
					l_prc.wait_for_exit_with_timeout (a_time_limit)
				else
					l_prc.wait_for_exit
				end
			end
			if not l_prc.has_exited then
				create Result.make_empty
			else
				from
					tmp_file.reopen_read (tmp_file.path.name)
					create Result.make_empty
				until
					tmp_file.end_of_file
				loop
					tmp_file.read_unicode_line
					Result := Result + tmp_file.last_string_32
				end
			end
		end

end
