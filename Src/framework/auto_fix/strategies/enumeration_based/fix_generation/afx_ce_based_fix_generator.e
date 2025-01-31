note
	description: "Summary description for {AFX_CE_BASED_FIX_GENERATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CE_BASED_FIX_GENERATOR

inherit

	AFX_SHARED_SESSION

	AFX_FIX_GENERATOR

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	SHARED_SERVER

	AFX_FIX_ID_SERVER

	INTERNAL_COMPILER_STRING_EXPORTER

	AFX_FIX_SKELETON_CONSTANT

	REFACTORING_HELPER

	EPA_COMPILATION_UTILITY

feature -- Fixing targets

	fixing_target_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET] assign set_fixing_target_list

	context_failure: AFX_PROOF_FAILURE
			-- Proof failure under fix

	set_fixing_target_list (a_list: like fixing_target_list)
		do
			fixing_target_list := a_list.twin
		end

	set_proof_failure (a_proof_failure: AFX_PROOF_FAILURE)
			-- Set `context_failure' as `a_proof_failure'
		do
			context_failure := a_proof_failure
		end

feature -- Basic operations

	generate
			-- <Precursor>
		local
			l_fixing_targets: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_ranking_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FIXING_TARGET]
			l_target: AFX_FIXING_TARGET
			l_max_target, l_max_fix: INTEGER
			l_count: INTEGER
			l_parser: ETR_PARSING_HELPER
			l_fixes: like fixes
			l_fix_text: STRING
		do
				--Initialize.
			create fixes.make_equal (100)

				-- Generate from (at most) `max_fixing_target's (at most) `max_fix_candidate' fixes.
			l_fixing_targets := fixing_target_list
			l_max_target := config.max_fixing_target.to_integer_32
			l_max_fix := config.max_fix_candidate.to_integer_32

			from
				l_ranking_cursor := l_fixing_targets.new_cursor
				l_ranking_cursor.start
				l_count := 0
			until
				l_ranking_cursor.after
				or else (l_max_target /= 0 and then l_count > l_max_target)
				or else (l_max_fix /= 0 and then fixes.count > l_max_fix)
				or else not session.should_continue
			loop
				l_target := l_ranking_cursor.item
				generate_fixes_for_target (l_target)

				l_count := l_count + 1
				l_ranking_cursor.forth
			end

			prune_fixes
		end

feature {NONE} -- Implementation

	generate_fixes_for_target (a_target: AFX_FIXING_TARGET)
			-- Generate fixes for `a_target'. Generated fixes are put into `fixes'.
		require
			target_attached: a_target /= Void
		local
			l_guard_conditions: DS_ARRAYED_LIST [EPA_EXPRESSION]
			l_relevant_asts: LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [EPA_AST_STRUCTURE_NODE]]]
			l_requirements: DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			l_condition: EPA_EXPRESSION
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
			l_instructions: LINKED_LIST [EPA_AST_STRUCTURE_NODE]
			l_match_list: LEAF_AS_LIST
		do
			l_guard_conditions := guard_conditions_for_target (a_target)
			l_relevant_asts := relevant_asts_for_a_target (a_target)
			l_requirements := change_requirements_for_target (a_target)

			from l_guard_conditions.start
			until l_guard_conditions.after
			loop
				l_condition := l_guard_conditions.item_for_iteration
				from l_requirements.start
				until l_requirements.after
				loop
					l_requirement := l_requirements.item_for_iteration
					from l_relevant_asts.start
					until l_relevant_asts.after
					loop
						l_instructions := l_relevant_asts.item_for_iteration.instructions
						l_match_list := a_target.context_class.match_list_server.item (a_target.context_class.class_id)
							-- extend the existing instructions in the current feature into the set of input instructions
						generate_one_fix (a_target, l_condition, l_requirement, l_instructions)

						l_relevant_asts.forth
					end

					l_requirements.forth
				end
				l_guard_conditions.forth
			end
		end

	generate_one_fix (a_target: AFX_FIXING_TARGET; a_condition: EPA_EXPRESSION; a_requirement: AFX_STATE_CHANGE_REQUIREMENT; a_instructions: LINKED_LIST [EPA_AST_STRUCTURE_NODE])
			-- Generate one fix using `a_condition', `a_requirement' around `a_instructions'.
			-- Put the generated fix into `fixes'.
		local
			l_written_class: CLASS_C
			l_match_list: LEAF_AS_LIST
			l_first_as, l_last_as: AST_EIFFEL
			l_state_change_assigner: AFX_STATE_CHANGE_ASSIGNER
			l_state_change_substitutor: AFX_STATE_CHANGE_SUBSTITUTOR
			l_assignment_operations: DS_ARRAYED_LIST [STRING]
			l_substitution_operations: DS_ARRAYED_LIST [STRING]
			l_operation: STRING
			l_instr: EPA_AST_STRUCTURE_NODE
			l_if_instruction, l_instruction: STRING
			l_feature_body_with_fix: STRING
			l_body_text_lines: LIST [STRING]
			l_feature_text_with_fix: STRING
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_fix_ranking: AFX_FIX_RANKING
			l_exception_recipient_feature: AFX_FEATURE_TO_MONITOR
			l_suspicious_blocks: ARRAY [INTEGER]
			l_block_id: INTEGER
			l_assertion: STRING
			l_src, l_dest: EPA_AST_EXPRESSION
			l_requirement: AFX_STATE_CHANGE_REQUIREMENT
		do
				-- print ("AFX_CE_BASED_FIX_GENERATOR.generate_one_fix%N")
			l_written_class := session.feature_under_proof.written_class
			l_exception_recipient_feature := session.feature_under_proof

			l_match_list := match_list_server.item (l_written_class.class_id)
			l_first_as := a_instructions.first.ast.ast
			l_last_as := a_instructions.last.ast.ast

				-- replace conditions in if-elseif-statement
			across a_instructions as inst loop
					-- if attached {EPA_AST_STRUCTURE_NODE} inst as l_node then
				if attached {LOOP_AS} inst.item.ast.ast as l_loop then
--					l_loop.stop.replace_text (a_target.expression.text, l_match_list)

--					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
--					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
--					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
--					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
--					fixes.force_last (l_fix)
--					l_match_list.remove_modifications

--					l_loop.stop.replace_text ("not (" + a_target.expression.text + ")", l_match_list)
--					print (l_loop.stop.text (l_match_list) + "%N") -- exit condition, this works!!

--					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
--					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
--					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
--					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
--					fixes.force_last (l_fix)
--					l_match_list.remove_modifications

--					l_loop.stop.replace_text (a_target.expression.text + " or (" + l_loop.stop.text (l_match_list) + ")", l_match_list)
--					print (l_loop.stop.text (l_match_list) + "%N") -- exit condition, this works!!

--					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
--					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
--					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
--					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
--					fixes.force_last (l_fix)
--					l_match_list.remove_modifications

--					l_loop.stop.replace_text ("not (" + a_target.expression.text + ")" + " or (" + l_loop.stop.text (l_match_list) + ")", l_match_list)
--					print (l_loop.stop.text (l_match_list) + "%N") -- exit condition, this works!!

--					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
--					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
--					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
--					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
--					fixes.force_last (l_fix)
--					l_match_list.remove_modifications

--					l_loop.stop.replace_text (a_target.expression.text + " and (" + l_loop.stop.text (l_match_list) + ")", l_match_list)
--					print (l_loop.stop.text (l_match_list) + "%N") -- exit condition, this works!!

--					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
--					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
--					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
--					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
--					fixes.force_last (l_fix)
--					l_match_list.remove_modifications

--					l_loop.stop.replace_text ("not (" + a_target.expression.text + ")" + " and (" + l_loop.stop.text (l_match_list) + ")", l_match_list)
--					print (l_loop.stop.text (l_match_list) + "%N") -- exit condition, this works!!

--					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
--					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
--					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
--					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
--					fixes.force_last (l_fix)
--					l_match_list.remove_modifications

				elseif attached {IF_AS} inst.item.ast.ast as l_if then
					l_if.condition.replace_text (a_target.expression.text, l_match_list)
						-- l_if.can_append_text (a_list: LEAF_AS_LIST)
						-- l_if.append_text ("%N Result := 0", l_match_list) -- at the same line after keyword "end"
						-- l_if.prepend_text ("%N%TResult := 0", l_match_list) -- same line after the do keyword

						-- l_if.end_keyword.prepend_text (a_text: STRING_8, a_list: LEAF_AS_LIST)
						-- l_if.compound.first.append_text ("-- Result := 0", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_if.condition.replace_text ("not (" + a_target.expression.text + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_if.condition.replace_text (a_target.expression.text + " or (" + l_if.condition.text (l_match_list) + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

						-- l_body_text_lines [l_body_text_lines.index].replace_substring ("if " + a_target.expression.text + " or ", 1, 5)
					l_if.condition.replace_text ("not (" + a_target.expression.text + ")" + " or (" + l_if.condition.text (l_match_list) + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_if.condition.replace_text (a_target.expression.text + " and (" + l_if.condition.text (l_match_list) + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

						-- l_body_text_lines [l_body_text_lines.index].replace_substring ("if " + a_target.expression.text + " or ", 1, 5)
					l_if.condition.replace_text ("not (" + a_target.expression.text + ")" + " and (" + l_if.condition.text (l_match_list) + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

				elseif attached {ELSIF_AS} inst.item.ast.ast as l_elsif then
					l_elsif.expr.replace_text (a_target.expression.text, l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_elsif.expr.replace_text ("not (" + a_target.expression.text + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_elsif.expr.replace_text (a_target.expression.text + " or (" + l_elsif.expr.text (l_match_list) + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_elsif.expr.replace_text ("not (" + a_target.expression.text + ")" + " or (" + l_elsif.expr.text (l_match_list) + ")", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

				elseif attached {INSPECT_AS} inst.item.ast.ast as l_inspect then
						-- Result := l_inspect.switch
				else
						-- Result := l_node.ast.ast
				end
			end

				-- Manipulate the instructions in the suspicious blocks
				-- 1) Identify the suspicious block based on the "passed_block value"
				-- if a_target.expression.text.has_substring ("passed_block") then
			l_suspicious_blocks := suspicious_blocks (a_target.expression.text)

				-- build new assignments based on the counterexample inv ariants

			l_assertion := assertion_of_tag (l_exception_recipient_feature, context_failure.failure_message) -- cannot catch the precondition text properly
				-- print (context_failure.assertion_tag + " " + l_assertion.out + "%N")
			if not l_assertion.is_empty then
				create l_src.make_with_text (l_written_class, l_exception_recipient_feature.feature_, l_assertion, l_written_class)
				create l_dest.make_with_text (l_written_class, l_exception_recipient_feature.feature_, "not (" + l_assertion + ")", l_written_class)
				create l_requirement.make (l_src, l_dest)

				create l_state_change_assigner
				l_state_change_assigner.generate_assignment (l_requirement)
				l_assignment_operations := l_state_change_assigner.last_operation_texts

				across l_assignment_operations as op loop
						-- a_instructions -- how to localize the suspicious block

					across a_instructions as inst loop
							-- l_block_id := l_block_id + 1
							-- print ("node: " + l_block_id.out + inst.item.debug_output + " breakpoint: " + inst.item.breakpoint_slot.out + "%N")
						inst.item.ast.ast.append_text ("%N%T" + op.item, l_match_list) -- same line after the do keyword

							-- l_if.end_keyword.prepend_text (a_text: STRING_8, a_list: LEAF_AS_LIST)
							-- l_if.compound.first.append_text ("-- Result := 0", l_match_list)
						l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
						l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
						create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
						l_fix.set_fixed_feature_text (l_feature_text_with_fix)
						fixes.force_last (l_fix)
						l_match_list.remove_modifications

						across inst.item.children as c loop -- this assumes that the code does not have nested structure
							across c.item as d loop
								d.item.ast.ast.replace_text ("%N%T" + op.item, l_match_list) -- replace the instruction
								l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
								l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
								create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
								l_fix.set_fixed_feature_text (l_feature_text_with_fix)
								fixes.force_last (l_fix)
								l_match_list.remove_modifications

								d.item.ast.ast.append_text ("%N%T" + op.item, l_match_list) -- add a new instruction
								l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
								l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
								create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
								l_fix.set_fixed_feature_text (l_feature_text_with_fix)
								fixes.force_last (l_fix)

								l_match_list.remove_modifications
							end
						end
					end
				end

			end

			across a_instructions as inst loop
				across inst.item.children as c loop -- this assumes that the code does not have nested structure
					across c.item as d loop
							-- replace "+" with "-" or the other way around
						l_instruction := ""
						l_instruction.copy (d.item.ast.ast.text (l_match_list))
						if l_instruction.has_substring ("+") then
							l_instruction.replace_substring_all ("+", "-")
							d.item.ast.ast.replace_text (l_instruction, l_match_list)
							l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
							l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
							create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
							l_fix.set_fixed_feature_text (l_feature_text_with_fix)
							fixes.force_last (l_fix)
							l_match_list.remove_modifications
						end

						l_instruction.copy (d.item.ast.ast.text (l_match_list))
						if l_instruction.has_substring ("-") then
							l_instruction.replace_substring_all ("-", "+")
							d.item.ast.ast.replace_text (l_instruction, l_match_list)
							l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
							l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
							create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
							l_fix.set_fixed_feature_text (l_feature_text_with_fix)
							fixes.force_last (l_fix)
							l_match_list.remove_modifications
						end
					end
				end
			end

			l_body_text_lines := l_exception_recipient_feature.body_ast.text (l_match_list).split ('%N')
			l_block_id := 1

			l_feature_body_with_fix := ""
			from
				l_body_text_lines.start
			until
				l_body_text_lines.after
			loop
				if l_body_text_lines.item.has_substring ("if ") or l_body_text_lines.item.has_substring ("else ") then
					l_block_id := l_block_id + 1
						-- 2) Form an instruction that changes the state of the variables relevant to the violated assertion
						-- what should be the requirement of state changes if we want to generate instructions randomly?
						-- the req should contain the variable
						-- can we obtain the violated assertion -- and passed it to the state change requirement
						-- l_assignment_operations
						-- 3) Replace the values of the assignment with common values/constants
						-- 4) Remove/add a routine call, mutate the plus into minus
					if l_suspicious_blocks.has (l_block_id) then
							-- extend the suspicious block by adding a new assignment at the end of the block

					end
				end
				l_feature_body_with_fix := l_feature_body_with_fix + l_body_text_lines.item.out
				l_body_text_lines.forth
			end

			create l_state_change_assigner
			l_state_change_assigner.generate_assignment (a_requirement)
			l_assignment_operations := l_state_change_assigner.last_operation_texts

				-- if not (failing_condition) then original_instr end
			l_if_instruction := "if not(" + a_condition.text + ") then%N"
			l_first_as.prepend_text (l_if_instruction, l_match_list)
			l_last_as.append_text ("%Nend%N", l_match_list)

			l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
			l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
			create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
			l_fix.set_fixed_feature_text (l_feature_text_with_fix)
			fixes.force_last (l_fix)
			l_match_list.remove_modifications
				-- The following two fixing schemes are only applied when `a_instructions' has only one instruction:
			if a_instructions.count = 1 then
				l_instr := a_instructions.first

				-- if l_instr.children.count = 0 then -- single assignment/call
					l_instruction := ""
					l_instruction.copy (l_instr.ast.ast.text (l_match_list))
					if l_instruction.has_substring ("+") then
						l_instruction.replace_substring_all ("+", "-")
						l_instr.ast.ast.replace_text (l_instruction, l_match_list)
						l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
						l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
						create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
						l_fix.set_fixed_feature_text (l_feature_text_with_fix)
						fixes.force_last (l_fix)
						l_match_list.remove_modifications
					end

					l_instruction.copy (l_instr.ast.ast.text (l_match_list))
					if l_instruction.has_substring ("-") then
						l_instruction.replace_substring_all ("-", "+")
						l_instr.ast.ast.replace_text (l_instruction, l_match_list)
						l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
						l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
						create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.Scheme_conditional_execute)
						l_fix.set_fixed_feature_text (l_feature_text_with_fix)
						fixes.force_last (l_fix)
						l_match_list.remove_modifications
					end
				-- end

					-- if failing_condi then fix_op end
				from l_assignment_operations.start
				until l_assignment_operations.after
				loop
					l_operation := l_assignment_operations.item_for_iteration

					l_if_instruction := "if " + a_condition.text + " then%N" + l_operation + "%Nend%N"
					l_first_as.prepend_text (l_if_instruction, l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.scheme_conditional_add)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_assignment_operations.forth
				end

					-- if failing_condi then fix_by_substitution else original_instru end
				create l_state_change_substitutor
				l_state_change_substitutor.perform (a_requirement, l_instr)
				l_substitution_operations := l_state_change_substitutor.last_operation_texts
				from l_substitution_operations.start
				until l_substitution_operations.after
				loop
					l_operation := l_substitution_operations.item_for_iteration

					l_if_instruction := "if " + a_condition.text + " then%N" + l_operation + "%Nelse%N"
					l_first_as.prepend_text (l_if_instruction, l_match_list)
					l_last_as.append_text ("%Nend%N", l_match_list)
					l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
					l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
					create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.scheme_conditional_replace)
					l_fix.set_fixed_feature_text (l_feature_text_with_fix)
					fixes.force_last (l_fix)
					l_match_list.remove_modifications

					l_substitution_operations.forth
				end
			end

				-- if failing_condition then fixing_operation else original_instr end
			from l_assignment_operations.start
			until l_assignment_operations.after
			loop
				l_operation := l_assignment_operations.item_for_iteration

				l_if_instruction := "if " + a_condition.text + " then%N" + l_operation + "%Nelse%N"
				l_first_as.prepend_text (l_if_instruction, l_match_list)
				l_last_as.append_text ("%Nend%N", l_match_list)
				l_feature_body_with_fix := l_exception_recipient_feature.body_ast.text (l_match_list).twin
				l_feature_text_with_fix := l_exception_recipient_feature.feature_as_ast.text (l_match_list).twin
				create l_fix.make (l_exception_recipient_feature, a_target, l_feature_body_with_fix, {AFX_CODE_FIX_TO_FAULT}.scheme_conditional_replace)
				l_fix.set_fixed_feature_text (l_feature_text_with_fix)
				fixes.force_last (l_fix)
				l_match_list.remove_modifications

				l_assignment_operations.forth
			end
		end

	assertion_of_tag (a_feature: AFX_FEATURE_TO_MONITOR; a_tag: STRING): STRING -- EPA_AST_EXPRESSION
			-- Return the assertion of tag `a_tag' in feature `a_feature'
		do
				-- TODO Li: handle other types of contracts -- precondition and check assertions
			Result := ""
			across a_feature.contract_extractor.postcondition_of_feature (a_feature.feature_, a_feature.context_class) as p loop
				if p.item.tag.same_string (a_tag) then
					Result := p.item.text
				end
			end
		end

	suspicious_blocks (a_str: STRING): ARRAY [INTEGER]
			-- Get the list of suspicious block ids
		local
			l_exprs: LIST [STRING]
		do
			create Result.make_empty

			l_exprs := a_str.split ('[').last.split (',')
			across l_exprs as exp loop
				if exp.is_last then
					exp.item.remove_tail (1)
				end
				Result.force (exp.item.to_integer, Result.count + 1)
			end
		end

	change_requirements_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [AFX_STATE_CHANGE_REQUIREMENT]
			-- State change requirements regarding one fixing target.
		require
			target_attached: a_target /= Void
		do
			if attached {AFX_PROGRAM_STATE_ASPECT} a_target.expression as lv_aspect then
				Result := lv_aspect.derived_change_requirements
			else
				create Result.make_default
			end
		end

	guard_conditions_for_target (a_target: AFX_FIXING_TARGET): DS_ARRAYED_LIST [EPA_EXPRESSION]
			-- Guard conditions that can be used in fixes regarding `a_target'.
			-- Such conditions are from failing_invariants - passing_invariants.
			-- The conditions are sorted in decreasing order of their relevance to the fixing target.
			-- An expression sharing more common sub-expressions with the target is ranked higher.
		require
			target_attached: a_target /= Void
		do
			create Result.make (3)
			Result.force_last (a_target.expression)
		end

	prune_fixes
			-- Prune duplicate fixes and ill-formed fixes.
		local
			l_fix_texts: DS_HASH_SET [STRING]
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CODE_FIX_TO_FAULT]
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_text: STRING
		do
			from
				create l_fix_texts.make_equal (fixes.count)
				l_fix_cursor := fixes.new_cursor
				l_fix_cursor.start
			until
				l_fix_cursor.after
			loop
				l_fix := l_fix_cursor.item
				l_text := l_fix.fixed_body_text
				if l_fix_texts.has (l_text) or else not is_wellformed_fix (l_fix) then
					fixes.remove_at_cursor (l_fix_cursor)
				else
					l_fix_texts.force (l_text)
					l_fix_cursor.forth
				end
			end
		end

	is_wellformed_fix (a_fix: AFX_CODE_FIX_TO_FAULT): BOOLEAN
			-- Is `a_fix' wellformed, i.e. will result in compilable code when applied?
		local
			l_class: EIFFEL_CLASS_C
			l_feat: FEATURE_I
			l_request: AFX_MELT_FEATURE_REQUEST
			l_byte_code: STRING
			l_body_id: INTEGER
			l_pattern_id: INTEGER
			l_data: TUPLE [byte_code: STRING; last_bpslot: INTEGER]
			l_retried: BOOLEAN
		do
			if not l_retried then
				l_class ?= a_fix.context_feature.written_class
				l_feat := a_fix.context_feature.feature_
				l_data := feature_byte_code_with_text (l_class, l_feat, "feature " + a_fix.fixed_feature_text, False)
					--l_data := feature_byte_code_with_text (l_class, l_feat, "feature " + "move_item (v: G)%N do%N (create {DEVELOPER_EXCEPTION}).raise %N end%N", False)
				Result := not l_data.byte_code.is_empty
			end
		rescue
			l_retried := True
			Result := False
			retry
		end

feature {NONE} -- Implementation operations

	remove_qualified_call_on_current (a_str: STRING)
			-- Remove qualified calls of form 'Current.xxx' from `a_str'.
			-- FIXME: This is a hack, assuming no comments in 'a_str'.
		local
			l_str: STRING
			l_start_index, l_count: INTEGER
			l_previous_char: CHARACTER
		do
			from
				l_start_index := 1
				l_str := "Current."
				l_count := l_str.count
			until
				l_start_index = 0 or else l_start_index >= a_str.count
			loop
				l_start_index := a_str.substring_index (l_str, l_start_index)
				if l_start_index > 0 then
					if l_start_index = 1 then
						a_str.remove_substring (l_start_index, l_start_index + l_count - 1)
					else
						l_previous_char := a_str.at (l_start_index - 1)
						if l_previous_char.is_alpha_numeric or else l_previous_char ~ '_' then
								-- part of ID. Do nothing.
						else
							a_str.remove_substring (l_start_index, l_start_index + l_count - 1)
						end
					end
					l_start_index := l_start_index + 1
				end
			end
		end

	relevant_asts_for_a_target (a_target: AFX_FIXING_TARGET): LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [EPA_AST_STRUCTURE_NODE]]]
			-- Relevant asts regarding the breakpoint position of `a_target'.
			-- For the moment, we only try to generate fixes before `a_target' or surrounding the single node or all the following nodes in the
			--	current instruction list.
		require
			target_attached: a_target /= Void
			valid_position: a_target.bp_index > 0
		local
			l_list: LINKED_LIST [TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [EPA_AST_STRUCTURE_NODE]]]
			l_tuple: TUPLE [scope_level: INTEGER_32; instructions: LINKED_LIST [EPA_AST_STRUCTURE_NODE]]
			l_bp_index, l_scope_level: INTEGER_32
			l_recipient: AFX_FEATURE_TO_MONITOR
			l_node: EPA_AST_STRUCTURE_NODE
			l_node_list: LINKED_LIST [EPA_AST_STRUCTURE_NODE]
		do
			create Result.make

			if session.config.is_proof_based_fixing then
				l_recipient := session.feature_under_proof
				l_scope_level := 1
				l_bp_index := a_target.bp_index

				l_node_list := l_recipient.ast_structure.instructions_in_block (l_bp_index)
					-- create l_node_list.make
					-- l_node_list.force (l_node)
				Result.force ([l_scope_level, l_node_list])
			else
				l_recipient := session.exception_from_execution.recipient_feature_with_context

				l_scope_level := 1

					-- Node list containing only the instruction right after the position of `a_target'.
				l_bp_index := a_target.bp_index

				from
					l_node := l_recipient.ast_structure.surrounding_instruction (l_bp_index)
				until
					l_node = Void or else l_node.is_feature_node or else l_scope_level > config.max_fixing_location_scope_level.to_integer_32
				loop
					create l_node_list.make
					l_node_list.force (l_node)
					Result.force ([l_scope_level, l_node_list])

						-- Node list containing all instructions after `a_target', but within the same instruction list.
					if attached {LINKED_LIST [EPA_AST_STRUCTURE_NODE]} l_recipient.ast_structure.instructions_in_block_as (l_node) as lt_list and then lt_list.count > 1 then
						create l_node_list.make
						from lt_list.start
						until lt_list.after
						loop
							l_node := lt_list.item_for_iteration
							if l_node.breakpoint_slot >= l_bp_index then
								l_node_list.force (l_node)
							end
							lt_list.forth
						end
						if l_node_list.count > 1 then
							Result.force ([l_scope_level, l_node_list])
						end
					end

					l_node := l_node.parent
					l_scope_level := l_scope_level + 1
				end
			end
		end

end

