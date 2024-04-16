note
	description: "Summary description for {AFX_PROGRAM_EXECUTION_INVARIANT_DETECTER}."
	author: ""
	date: "$Date: 2014-03-13 21:12:57 +0800 (Thu, 13 Mar 2014) $"
	revision: "$Revision: 94594 $"

class
	AFX_INVARIANT_DETECTER

inherit
	EPA_PROCESS_UTILITY

	EPA_UTILITY

	AFX_SHARED_SESSION

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

--	AFX_SHARED_DYNAMIC_ANALYSIS_REPORT

feature -- Basic operation

	reset_detector
			-- Reset the internal state of the object.
		do
				-- invariants_from_passing_cell.put (Void)
				-- invariants_from_failing_cell.put (Void)
		end

	detect (a_is_proof_based_fixing: BOOLEAN; a_ce_traces: DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE])
			-- Detect invariants based one `trace_repository'.
			-- Make the invariants available in `invariants_from_passing' and `invariants_from_failing'.
		do
			reset_detector
			if a_is_proof_based_fixing then
				create invariants_from_ce_cell.put (invariants_from_ce_traces (a_ce_traces))
			else
					-- invariants_from_passing_cell.put (invariants_from_execution_traces (trace_repository.passing_traces))
					-- invariants_from_failing_cell.put (invariants_from_execution_traces (trace_repository.failing_traces))
			end
		end

feature {NONE} -- Implementation

	invariants_from_ce_traces (a_ce_traces: DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE]): DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS]
			-- Invariants inferred based on execution traces from `a_repository'.
			-- Key: name of the program point, in the format of "class_name.feature_name@bp_index".
			-- Val: set of expressions as invariants.
		local
			l_input_file_passing, l_input_file_failing: PLAIN_TEXT_FILE
			l_declaration_file: PLAIN_TEXT_FILE
			l_trace_file: PLAIN_TEXT_FILE
			l_daikon_output: STRING
			l_parser: DKN_RESULT_PARSER
			l_invariants: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_ppt: DKN_PROGRAM_POINT
			l_inv_set: DS_HASH_SET [DKN_INVARIANT]
			l_exp_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_time_left: INTEGER
		do
			if true then -- session.should_continue then -- TODO Li: recover
				if a_ce_traces.is_empty then
					create Result.make_equal (1)
				else
						-- Prepare input file for Daikon.
					daikon_ce_trace_printer.set_state_skeleton (session.feature_under_proof.skeletons_at_breakpoints.first) -- TODO Li, which skeleton should be chosen?
					daikon_ce_trace_printer.print_ce_trace_repository (a_ce_traces)
					create l_declaration_file.make_with_path (declaration_file_name)
					l_declaration_file.create_read_write
					l_declaration_file.put_string (daikon_ce_trace_printer.last_declarations.out)
					l_declaration_file.close
					create l_trace_file.make_with_path (trace_file_name)
					l_trace_file.create_read_write
					l_trace_file.put_string (daikon_ce_trace_printer.last_trace.out)
					l_trace_file.close
					-- print ("trace_file_name: " + trace_file_name.out + "%N")
						-- Execute Daikon.
					l_daikon_output := output_from_program_with_input_file_and_time_limit (daikon_command, Void, Void, l_time_left)
					-- print ("daikon output: " + l_daikon_output + "%N")
					if not l_daikon_output.is_empty then
							-- Retrieve Daikon result.
						create l_parser
						l_parser.parse_from_string (l_daikon_output, daikon_ce_trace_printer.last_declarations)
						l_invariants := l_parser.last_daikon_results

						Result := daikon_results_to_invariant_expressions (l_invariants)
					end
				end
			end
		end

	invariants_from_execution_traces (a_repository: DS_HASH_TABLE [AFX_PROGRAM_EXECUTION_TRACE, EPA_TEST_CASE_INFO]): DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS]
			-- Invariants inferred based on execution traces from `a_repository'.
			-- Key: name of the program point, in the format of "class_name.feature_name@bp_index".
			-- Val: set of expressions as invariants.
		local
			l_input_file_passing, l_input_file_failing: PLAIN_TEXT_FILE
			l_declaration_file: PLAIN_TEXT_FILE
			l_trace_file: PLAIN_TEXT_FILE
			l_daikon_output: STRING
			l_parser: DKN_RESULT_PARSER
			l_invariants: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_ppt: DKN_PROGRAM_POINT
			l_inv_set: DS_HASH_SET [DKN_INVARIANT]
			l_exp_set: EPA_HASH_SET [AFX_PROGRAM_STATE_EXPRESSION]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_time_left: INTEGER
		do
			if session.should_continue then
				if a_repository.is_empty then
					create Result.make_equal (1)
				else
						-- Prepare input file for Daikon.
					daikon_program_execution_printer.set_state_skeleton (session.exception_from_execution.recipient_feature_with_context.state_skeleton_in_body)
					daikon_program_execution_printer.print_trace_repository (a_repository)
					create l_declaration_file.make_with_path (declaration_file_name)
					l_declaration_file.create_read_write
					l_declaration_file.put_string (daikon_program_execution_printer.last_declarations.out)
					l_declaration_file.close
					create l_trace_file.make_with_path (trace_file_name)
					l_trace_file.create_read_write
					l_trace_file.put_string (daikon_program_execution_printer.last_trace.out)
					l_trace_file.close

						-- Execute Daikon.
					l_daikon_output := output_from_program_with_input_file_and_time_limit (daikon_command, Void, Void, l_time_left)
					if not l_daikon_output.is_empty then
							-- Retrieve Daikon result.
						create l_parser
						l_parser.parse_from_string (l_daikon_output, daikon_program_execution_printer.last_declarations)
						l_invariants := l_parser.last_daikon_results

						Result := daikon_results_to_invariant_expressions (l_invariants)
					end
				end
			end
		end

	daikon_results_to_invariant_expressions (a_results: DS_HASH_TABLE [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]): DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS]
			-- Invariants as states at breakpoints, from daikon results.
			-- Key: breakpoint
			-- Val: state invariant at each breakpoint
		local
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [DKN_INVARIANT], DKN_PROGRAM_POINT]
			l_ppt: DKN_PROGRAM_POINT
			l_inv_set: DS_HASH_SET [DKN_INVARIANT]
			l_set_cursor: DS_HASH_SET_CURSOR [DKN_INVARIANT]
			l_table_for_feature: DS_HASH_TABLE [EPA_STATE, INTEGER]
			l_class: CLASS_C
			l_feature: FEATURE_I
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_bp_index: INTEGER
			l_state: EPA_STATE
			l_inv_text: STRING
			l_equation: EPA_EQUATION
		do
			create Result.make_equal (20)
			Result.set_key_equality_tester (
				create {AGENT_BASED_EQUALITY_TESTER [EPA_FEATURE_WITH_CONTEXT_CLASS]}.make (
					agent (u, v: EPA_FEATURE_WITH_CONTEXT_CLASS): BOOLEAN
						do
							Result := (u.context_class.class_id = v.context_class.class_id
									and then u.feature_.rout_id_set ~ v.feature_.rout_id_set)
						end))

			from
				create l_table_cursor.make (a_results)
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_ppt := l_table_cursor.key
				l_inv_set := l_table_cursor.item

				l_class := first_class_starts_with_name (l_ppt.class_name)
				l_feature := l_class.feature_named (l_ppt.feature_name)
				l_bp_index := l_ppt.bp_index
				create l_feature_with_context.make (l_feature, l_class)

					-- Invariant state for one program point.
				from
					create l_state.make (l_inv_set.count + 1, l_class, l_feature)
					create l_set_cursor.make (l_inv_set)
					l_set_cursor.start
				until
					l_set_cursor.after
				loop
					if attached {DKN_EXPRESSION_INVARIANT} l_set_cursor.item as lvt_inv then
						l_inv_text := lvt_inv.text
						l_equation := equation_from_invariant_str (l_inv_text, l_class, l_feature)
						if l_equation /= Void then
							l_state.force (l_equation)
						end
					end

					l_set_cursor.forth
				end

					-- Relate invariant state to context feature and breakpoint.
				if Result.has (l_feature_with_context) then
					l_table_for_feature := Result.item (l_feature_with_context)
				else
					create l_table_for_feature.make_equal (15)
					Result.force (l_table_for_feature, l_feature_with_context)
				end
				l_table_for_feature.force (l_state, l_bp_index)

				l_table_cursor.forth
			end
		end

	equation_from_invariant_str (a_str: STRING; a_class: CLASS_C; a_feature: FEATURE_I): EPA_EQUATION
			--Equation parsed from `a_str'.
		local
			l_index: INTEGER
			l_expression_str, l_value_str: STRING
			l_expression: EPA_AST_EXPRESSION
			l_boolean_value: EPA_BOOLEAN_VALUE
			l_integer_value: EPA_INTEGER_VALUE
			l_tokens: LIST [STRING]
			l_equation: EPA_EQUATION
			l_expr: STRING
		do
				-- TODO Li: deal with expressions with no "==" operator
			if a_str.has_substring ("==") and (a_str.has_substring ("true") or a_str.has_substring ("false")) then
				l_index := a_str.substring_index ("==", 1)
				check only_separator: a_str.substring_index ("==", l_index + 1) = 0 end

				if not (l_index = 0) then
					l_expression_str := a_str.substring (1, l_index - 1)
				elseif not a_str.has_substring ("one of") then
					l_expression_str := a_str
				end

				l_value_str := a_str.substring (l_index + 2, a_str.count)
				l_value_str.left_adjust
				l_value_str.right_adjust
			elseif a_str.has_substring ("==") then
				l_expression_str := a_str
				l_expression_str.replace_substring_all ("==", "=")
				l_value_str := "true"
			else
				l_expression_str := a_str
				l_value_str := "true"
			end

			create l_expression.make_with_text (a_class, a_feature, l_expression_str, a_feature.written_class)

				if attached l_expression.type and then l_expression.type.is_integer and then l_value_str.is_integer then
					create l_integer_value.make (l_value_str.to_integer)
					create l_equation.make (l_expression, l_integer_value)
				elseif attached l_expression.type and then l_expression.type.is_boolean then
					if l_value_str.is_boolean then
						create l_boolean_value.make (l_value_str.to_boolean)
					else
						create l_boolean_value.make (True) -- by default, the expression is true
					end
					create l_equation.make (l_expression, l_boolean_value)
--				elseif l_expression_str.has_substring ("==") then -- and l_value_str.is_integer then
--					create l_expression.make_with_text (a_class, a_feature, l_expression_str, a_feature.written_class)
--					create l_boolean_value.make (True)
--					create l_equation.make (l_expression, l_boolean_value)
--				-- elseif l_expression_str.has_substring ("==") then
				--	create l_boolean_value.make (True)
				--	create l_equation.make (l_expression, l_boolean_value)
				end
			Result := l_equation
		end

feature {NONE} -- Implementation

	daikon_ce_trace_printer: AFX_CE_TRACE_TO_DAIKON_PRINTER
			-- Printer that prepares the input for Daikon.
		once
			create Result.make
		end

	daikon_program_execution_printer: AFX_PROGRAM_EXECUTION_TRACE_TO_DAIKON_PRINTER
			-- Printer that prepares the input for Daikon.
		once
			create Result.make
		end

	declaration_file_name: PATH
			-- Declaration file name for Daikon.
		do
			Result := session.eiffel_system.eiffel_project.project_directory.path.extended ("daikon_input.decls")
		end

	trace_file_name: PATH
			-- Trace file name.
		do
			Result := session.eiffel_system.eiffel_project.project_directory.path.extended ("daikon_input.dtrace")
		end

	daikon_command: STRING
			-- Command line option to launch daikon
		do
			create Result.make (256)
			if {PLATFORM}.is_windows then
					-- Result.append ("java -cp %%DAIKONDIR%%\daikon.jar daikon.Daikon ") -- TODO: recover
				Result.append ("java -cp D:\Daikon\daikon.jar daikon.Daikon ")
			else
				Result.append ("/usr/bin/java daikon.Daikon ")
			end

			Result.append (declaration_file_name.utf_8_name)
			Result.append_character (' ')
			Result.append (trace_file_name.utf_8_name)

			-- print ("Daikon command: " + Result + "%N")
		end

feature -- Inference result
	invariants_from_ce_cell: CELL [DS_HASH_TABLE [DS_HASH_TABLE [EPA_STATE, INTEGER], EPA_FEATURE_WITH_CONTEXT_CLASS]]

end
