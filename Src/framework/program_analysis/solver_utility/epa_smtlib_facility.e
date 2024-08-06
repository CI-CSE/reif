note
	description: "Summary description for {AFX_SMTLIB_LAUNCHER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_SMTLIB_FACILITY

inherit
	EPA_SOLVER_FACILITY

	EPA_PROCESS_UTILITY

--feature -- Basic operations

--	is_unsat (a_content: STRING): BOOLEAN
--			-- Is the SMTLIB content `a_content' unsatisfiable?
--		local
--			l_output: STRING
--		do
--			generate_file (a_content)
--			l_output := z3_output
--			l_output.replace_substring_all ("%R", "")
--			l_output.replace_substring_all ("%N", "")
--			Result := l_output.is_equal ("unsat")
--		end

feature{NONE} -- Implementation

	smtlib_file_directory: STRING = "/tmp"

	smtlib_file_path: STRING = "/tmp/autofix.smt"
			-- Full path of the generated smtlib file

	z3_command: STRING = "/bin/sh -c %"/home/jasonw/apps/z3/bin/z3.exe /smt: autofix.smt%""
			-- Command to launch Z3 SMT solver

	generate_file (a_content: STRING)
			-- Generate SMTLIB file at `smtlib_file_path' containing
			-- `a_content'.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_create_read_write (smtlib_file_path)
			l_file.put_string (a_content)
			l_file.close
		end

	z3_output: STRING
			-- Output from Z3 after applied to `smtlib_file_path'.
		do
			Result := output_from_program (z3_command, smtlib_file_directory)
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
