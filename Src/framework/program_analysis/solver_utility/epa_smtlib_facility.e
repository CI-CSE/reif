note
	description: "Summary description for {AFX_SMTLIB_LAUNCHER}."
	author: ""
	date: "$Date: 2011-02-27 02:46:47 +0800 (Sun, 27 Feb 2011) $"
	revision: "$Revision: 85731 $"

class
	EPA_SMTLIB_FACILITY

inherit
	EPA_SOLVER_FACILITY

feature -- Basic operations

	is_unsat (a_content: STRING): BOOLEAN
			-- Is the SMTLIB content `a_content' unsatisfiable?
		local
			l_output: STRING
		do
			generate_file (a_content)
			l_output := z3_output
			print ("SMT out: " + z3_output + "%N")
			l_output.replace_substring_all ("%R", "")
			l_output.replace_substring_all ("%N", "")
			Result := l_output.is_equal ("unsat")
		end

feature{NONE} -- Implementation

	smtlib_file_directory: STRING = "F:\PhD\WIP\MCDC"

	smtlib_file_path: STRING = "F:\PhD\WIP\MCDC\testMCDC.smt"
			-- Full path of the generated smtlib file

	z3_command: STRING = "z3 testMCDC.smt%""
			-- Command to launch Z3 SMT solver

	generate_file (a_content: STRING)
			-- Generate SMTLIB file at `smtlib_file_path' containing
			-- `a_content'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (smtlib_file_path)
			l_file.put_string (smt_header)
			l_file.put_string (a_content)
			l_file.put_string (smt_check_sat_command)
			l_file.close
		end

	z3_output: STRING
			-- Output from Z3 after applied to `smtlib_file_path'.
		local
			l_prc_factory: PROCESS_FACTORY
			l_prc: PROCESS
		do
			create output_buffer.make (1024)
			create l_prc_factory
			l_prc := l_prc_factory.process_launcher_with_command_line (z3_command, smtlib_file_directory)
			l_prc.redirect_output_to_agent (agent append_output_buffer)
			l_prc.redirect_error_to_same_as_output
			l_prc.launch
			if l_prc.launched then
				l_prc.wait_for_exit
			end
			Result := output_buffer.twin
		end

	output_buffer: STRING
			-- Output buffer for Z3

	append_output_buffer (a_output: STRING)
			-- Append `a_output' into `output_buffer'.
		do
			output_buffer.append (a_output)
		end

	smt_header: STRING
		once
			Result := "(set-option :print-success false)%N"
						+ "(set-info :smt-lib-version 2.6)%N"
						+ "(set-option :produce-models true)%N"
						+ "(set-option :smt.mbqi false)%N"
						+ "(set-option :model.compact false)%N"
						+ "(set-option :model.v2 true)%N"
						+ "(set-option :pp.bv_literals false)%N"
		end

	smt_check_sat_command: STRING
		once
			Result := "(check-sat)%N" + "(get-model)%N"
		end

	solver_output (a_content: STRING): STRING
			-- Output from the solver for input `a_content'
		do
		end

	solver_output_for_expressions (a_expressions: LINEAR [EPA_EXPRESSION]; a_solver_input: STRING): HASH_TABLE [STRING, EPA_EXPRESSION]
			-- Output from the solver for checking `a_expressions' in the context of `a_solver_input'.
			-- `a_solver_input' is the input fed to the underlying theorem prover.
			-- Result is a table, key is the expression, value is the solver output for that expression':
			-- output can be either "verified" or "error".
		do
		end

end
