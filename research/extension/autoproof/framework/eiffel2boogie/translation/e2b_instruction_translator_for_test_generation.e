note
	description: "Summary description for {E2B_MCDC_INSTRUCTION_TRANSLATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_INSTRUCTION_TRANSLATOR_FOR_TEST_GENERATION

inherit

	E2B_INSTRUCTION_TRANSLATOR
	redefine
		process_if_b,
		process_loop_b,
		process_from_loop_normal,
		process_loop_unrolled,
		process_loop_invariants,
		process_expression
	end

create make

feature

	process_if_b (a_node: IF_B)
			-- <Precursor>
		local
			l_if: IV_CONDITIONAL
			l_nested_if: IV_CONDITIONAL
			l_temp_block: IV_BLOCK
			l_then_orgin_info, l_else_origin_info: IV_STATEMENT_ORIGIN
			l_nested_then_orgin_info, l_nested_else_origin_info: IV_STATEMENT_ORIGIN
			l_line_number: INTEGER
		do
			current_implementation.set_has_conditional (True)
			current_implementation.procedure.set_has_conditional (True)
			current_conditional := a_node

			set_current_origin_information (a_node)

			l_temp_block := current_block
			create l_then_orgin_info
			create l_else_origin_info
			create l_nested_then_orgin_info
			create l_nested_else_origin_info

			process_expression (a_node.condition)
			create l_if.make (last_expression)
			add_statement (l_if)

				-- then block
			current_block := l_if.then_block
			process_compound (a_node.compound)

			if options.is_unrolling_loop and then current_block.is_conditional_leaf (True, Void) then
				options.set_number_of_branches_of_current_loop (options.number_of_branches_of_current_loop + 1)
				current_block.set_is_unrolled_block (True)
			end

				-- get the first line of the compound as the line number of the then_block
				-- set information for the then block
			l_then_orgin_info.set_file (current_feature.written_class.file_name)
			l_line_number := a_node.compound.line_number
			l_then_orgin_info.set_line (l_line_number)
			l_if.then_block.set_origin_information (l_then_orgin_info)
			update_ghost_status (a_node, l_if)

				-- elseif blocks
			current_block := l_if.else_block

			if attached a_node.elsif_list as ls then
				across
					ls as l
				loop
					check
						attached {ELSIF_B} l as l_elseif
					then

						set_current_origin_information (l_elseif)
							-- elseif condition
						l_line_number := l_elseif.compound.line_number

						l_else_origin_info.set_file (current_feature.written_class.file_name)
						l_else_origin_info.set_line (l_line_number)
						l_if.else_block.set_origin_information (l_else_origin_info)

						options.reset_num_bin_op_of_cond
						process_expression (l_elseif.expr)
						create l_nested_if.make (last_expression)
						add_statement (l_nested_if)
						update_ghost_status (a_node, l_nested_if)

							-- elseif block
						current_block := l_nested_if.then_block

						if options.is_unrolling_loop and then current_block.is_conditional_leaf (True, Void) then
							options.set_number_of_branches_of_current_loop (options.number_of_branches_of_current_loop + 1)
							current_block.set_is_unrolled_block (True)
						end

						process_compound (l_elseif.compound)
						l_nested_then_orgin_info.set_file (current_feature.written_class.file_name)
						l_nested_then_orgin_info.set_line (l_elseif.compound.line_number)
						l_nested_if.then_block.set_origin_information (l_nested_then_orgin_info)

							-- else block
						current_block := l_nested_if.else_block

						if options.is_unrolling_loop and then current_block.is_conditional_leaf (True, Void) then
							options.set_number_of_branches_of_current_loop (options.number_of_branches_of_current_loop + 1)
							current_block.set_is_unrolled_block (True)
						end
					end
				end
			end

				-- else block
			if attached a_node.else_part as e then
				process_compound (e)
					-- a_node.else_part.mark_last_instruction.
				set_current_origin_information (a_node.else_part)
				l_line_number := a_node.else_part.line_number
				l_else_origin_info.set_file (current_feature.written_class.file_name)
				l_else_origin_info.set_line (l_line_number)
				l_if.else_block.set_origin_information (l_else_origin_info)
				if options.is_unrolling_loop and then l_if.else_block.is_conditional_leaf (True, Void) then
					options.set_number_of_branches_of_current_loop (options.number_of_branches_of_current_loop + 1)
					l_if.else_block.set_is_unrolled_block (True)
				end
			end

				-- restore context
			current_block := l_temp_block
		end

	process_loop_b (a_node: LOOP_B)
			-- <Precursor>
		do
			current_implementation.set_has_conditional (True)

			if options.is_automatic_loop_unrolling_enabled and (a_node.invariant_part = Void or options.is_full_coverage_test_generation_enabled) then
				process_loop_unrolled (a_node)
			else
				process_loop_normal (a_node)
			end
		end

	process_from_loop_normal (a_node: LOOP_B)
			-- Process from loop in normal way.
		local
			l_pre_heap: IV_ENTITY
			l_frame: like process_loop_modifies
			l_old_writable: IV_EXPRESSION
			l_condition: IV_EXPRESSION
			l_goto: IV_GOTO
			l_temp_block, l_head_block, l_body_block, l_end_block: IV_BLOCK
			l_assume: IV_ASSERT
			l_variant_locals: ARRAYED_LIST [IV_ENTITY]
			l_variant_exprs: ARRAYED_LIST [IV_EXPRESSION]
			l_assignment: IV_ASSIGNMENT
			l_modifies, l_decreases: ARRAYED_LIST [E2B_ASSERT_ORIGIN]
			l_translator: E2B_BODY_EXPRESSION_TRANSLATOR
			l_test_suite: ARRAYED_LIST [ARRAYED_LIST [BOOLEAN]]
			l_if: IV_CONDITIONAL
		do
			set_current_origin_information (a_node)

			l_temp_block := current_block
			create l_head_block.make_name (helper.unique_identifier ("loop_head"))
			create l_body_block.make_name (helper.unique_identifier ("loop_body"))
			create l_end_block.make_name (helper.unique_identifier ("loop_end"))

				-- From part
			if a_node.from_part /= Void then
				a_node.from_part.process (Current)
			end

				-- Save pre-loop state
			create l_pre_heap.make (helper.unique_identifier ("PreLoopHeap"), types.heap)
			current_implementation.add_local (l_pre_heap.name, l_pre_heap.type)
			create l_assignment.make (l_pre_heap, entity_mapping.heap)
			add_statement (l_assignment)

				-- Collect modify and decreases clauses
			create l_modifies.make (3)
			create l_decreases.make (3)
			if attached a_node.invariant_part as i then
				across
					i as node
				loop
					if not attached {ASSERT_B} node as l_invariant then
							-- Unexpected byte node.
					elseif helper.is_clause_modify (l_invariant) then
						l_modifies.extend (create {E2B_ASSERT_ORIGIN}.make (l_invariant, current_feature.written_class))
					elseif helper.is_clause_decreases (l_invariant) then
						l_decreases.extend (create {E2B_ASSERT_ORIGIN}.make (l_invariant, current_feature.written_class))
					end
				end
			end

				-- Process modifies
			l_frame := process_loop_modifies (l_modifies)
			l_old_writable := local_writable
			local_writable := l_frame.writable

				-- Goto head
			create l_goto.make (l_head_block)
			add_statement (l_goto)
			add_statement (l_head_block)
			current_block := l_head_block

				-- Process invariants
			process_loop_invariants (a_node.invariant_part, l_pre_heap, l_frame.frame)

				-- Condition
			set_current_origin_information (a_node.stop)

			if options.is_full_mcdc_test_generation_enabled then
				create {E2B_MCDC_DECISION_COLLECTOR} l_translator.make
				l_translator.set_context (current_feature, current_type)
				l_translator.set_context_implementation (current_implementation)
				if attached current_origin_information as coi then
					l_translator.set_context_line_number (coi.line)
				end
				l_translator.copy_entity_mapping (entity_mapping)
				l_translator.locals_map.merge (locals_map)
				l_translator.set_local_writable (local_writable)
				l_translator.set_context_readable (context_readable)
				a_node.stop.process (l_translator)

				if not options.mcdc_decision_exprs.is_empty then
					l_test_suite := mcdc_of_decision (options.mcdc_decision_exprs.first)

					across l_test_suite as l_test loop
						process_mcdc_expression (options.mcdc_decision_exprs.first, l_test)
						create l_if.make (last_expression)
						add_statement (l_if)
					end
					options.mcdc_decision_exprs.wipe_out
				end
			end

			process_contract_expression (a_node.stop, False)

			across last_safety_checks as i loop
				add_statement (i)
			end

			l_condition := last_expression
			create l_goto.make (l_body_block)
			l_goto.add_target (l_end_block)
			add_statement (l_goto)
			current_block := l_temp_block

				-- Body block
			add_statement (l_body_block)
			current_block := l_body_block
			create l_assume.make_assume (factory.not_ (l_condition))
			add_statement (l_assume)

				-- Variant initialization
			create l_variant_exprs.make (3)
			create l_variant_locals.make (3)
			process_loop_variants (a_node.variant_part, l_decreases, l_condition, l_variant_exprs, l_variant_locals)

				-- Body
			process_compound (a_node.compound)

				-- Variant checks
			if a_node.variant_part /= Void and l_variant_exprs.count = 1 then
				set_current_origin_information (a_node.variant_part)
			elseif a_node.compound /= Void then
				set_current_origin_information (a_node.compound)
			else
				set_current_origin_information (a_node)
			end

			if not options.is_full_coverage_test_generation_enabled and not options.is_full_mcdc_test_generation_enabled then -- disable termination check when generating tests
				add_termination_check (l_variant_locals, l_variant_exprs)
			end

				-- Goto head
			create l_goto.make (l_head_block)
			add_statement (l_goto)
			current_block := l_temp_block

				-- End
			add_statement (l_end_block)
			current_block := l_end_block
			create l_assume.make_assume (l_condition)
			add_statement (l_assume)

				-- Revert to the old local writable
			local_writable := l_old_writable

			current_block := l_temp_block
		end


	process_loop_unrolled (a_node: LOOP_B)
			-- Process loop with unrolling.
		local
			l_condition: IV_EXPRESSION
			l_goto: IV_GOTO
			l_temp_block, l_head_block, l_body_block, l_end_block, l_force_end_block: IV_BLOCK
			l_assert: IV_ASSERT
			l_assume: IV_ASSERT
			l_not: IV_UNARY_OPERATION
			l_op, l_eq: IV_BINARY_OPERATION
			l_variant: IV_ENTITY
			l_assignment: IV_ASSIGNMENT
			l_unroll_counter: INTEGER
		do
			options.set_is_unrolling_loop (True)
			l_temp_block := current_block

				-- Init condition
			set_current_origin_information (a_node.stop)
			process_expression (a_node.stop)
			l_condition := last_expression

				-- Init variant
			if a_node.variant_part /= Void then
				create l_variant.make (helper.unique_identifier ("variant"), types.int)
				current_implementation.add_local (l_variant.name, types.int)
			end

				-- Init end block
			l_temp_block := current_block
			create l_end_block.make_name (helper.unique_identifier ("loop_end"))

				-- From part
			set_current_origin_information (a_node)
			if a_node.from_part /= Void then
				a_node.from_part.process (Current)
			end

				-- Unrolled body
			from
				l_unroll_counter := 1
			until
				l_unroll_counter > options.loop_unrolling_depth
			loop
				create l_head_block.make_name (helper.unique_identifier ("loop_head" + l_unroll_counter.out))
				create l_body_block.make_name (helper.unique_identifier ("loop_body" + l_unroll_counter.out))

					-- goto head
				create l_goto.make (l_head_block)
				add_statement (l_goto)

					-- head
				current_block := l_temp_block
				add_statement (l_head_block)
				current_block := l_head_block

					-- Invariants
				if attached a_node.invariant_part as i then
					across
						i as node
					loop
						if attached {ASSERT_B} node as l_invariant then
							set_current_origin_information (l_invariant)
							process_contract_expression (l_invariant.expr, False)
							create l_assert.make (last_expression)
							l_assert.node_info.set_type ("loop_inv")
							l_assert.node_info.set_tag (l_invariant.tag)
							l_assert.node_info.set_line (l_invariant.line_number)
							add_statement (l_assert)
						end
					end
				end

					-- Variant
				if a_node.variant_part /= Void then
					set_current_origin_information (a_node.variant_part)
					process_expression (a_node.variant_part.expr)
					create l_assignment.make (l_variant, last_expression)
					add_statement (l_assignment)
					create l_op.make (l_variant, ">=", create {IV_VALUE}.make ("0", types.int), types.bool)
					create l_assert.make (l_op)
					l_assert.node_info.set_type ("loop_var_ge_zero")
					add_statement (l_assert)
				end

					-- goto end or body
				create l_goto.make (l_body_block)
				l_goto.add_target (l_end_block)
				add_statement (l_goto)

					-- body
				current_block := l_temp_block
				l_body_block.set_is_unrolled_block (options.is_unrolling_loop)
				add_statement (l_body_block)
				current_block := l_body_block

				create l_not.make ("!", l_condition, types.bool)
				create l_assume.make_assume (l_not)
				add_statement (l_assume)
				options.set_number_of_branches_of_current_loop (0)
				process_compound (a_node.compound)

				if a_node.variant_part /= Void then
					set_current_origin_information (a_node.variant_part)
					process_expression (a_node.variant_part.expr)
					create l_op.make (last_expression, "<", l_variant, types.bool)
					create l_assert.make (l_op)
					l_assert.node_info.set_type ("loop_var_decr")
					add_statement (l_assert)
				end

					-- add check assertion for test generation
				if options.is_full_coverage_test_generation_enabled then
					if options.number_of_branches_of_current_loop = 0 then
						create l_not.make ("!", l_condition, types.bool)
						create l_assert.make (l_not)
						l_assert.node_info.set_type ("contradiction clause")
						add_statement (l_assert)
					else
						across ((l_unroll_counter - 1) * options.number_of_branches_of_current_loop + 1) |..| (l_unroll_counter * options.number_of_branches_of_current_loop) as i loop
							create l_eq.make (create {IV_ENTITY}.make ("bnu", types.int), "==", create {IV_VALUE}.make (i.out, types.int), types.bool)
							create l_op.make (l_condition, "&&", l_eq, types.bool)
							create l_not.make ("!", l_op, types.bool)
							create l_assert.make (l_not)
							l_assert.node_info.set_type ("contradiction clause")
							add_statement (l_assert)
						end
					end
				end

				l_unroll_counter := l_unroll_counter + 1
			end

			options.set_is_unrolling_loop (False)

			if options.is_sound_loop_unrolling_enabled then
				create l_goto.make (l_head_block)
				add_statement (l_goto)
			else
				create l_force_end_block.make_name (helper.unique_identifier ("force_end"))
				create l_goto.make (l_force_end_block)
				add_statement (l_goto)

					-- force end
				current_block := l_temp_block
				add_statement (l_force_end_block)
				current_block := l_force_end_block

					-- Invariants
				if attached a_node.invariant_part as i then
					across
						i as node
					loop
						if attached {ASSERT_B} node as l_invariant then
							set_current_origin_information (l_invariant)
							process_contract_expression (l_invariant.expr, False)
							create l_assert.make (last_expression)
							add_statement (l_assert)
						end
					end
				end

					-- Variant
				if a_node.variant_part /= Void then
					set_current_origin_information (a_node.variant_part)
					current_implementation.add_local (l_variant.name, types.int)
					process_expression (a_node.variant_part.expr)
					create l_assignment.make (l_variant, last_expression)
					add_statement (l_assignment)
					create l_op.make (l_variant, ">=", create {IV_VALUE}.make ("0", types.int), types.bool)
					create l_assert.make (l_op)
					add_statement (l_assert)
				end
			end

				-- end
			current_block := l_temp_block
			add_statement (l_end_block)
			current_block := l_end_block

			create l_assume.make_assume (l_condition)
			add_statement (l_assume)

			current_block := l_temp_block
		end

	process_loop_invariants (a_invariants: BYTE_LIST [BYTE_NODE]; a_pre_heap, a_loop_frame: IV_EXPRESSION)
			-- Process loop invariants `a_invariants' and add default invariants
			-- with pre-loop heap `a_pre-heap' and the loop frame `a_loop_frame' (if exists, otherwise Void).
		local
			l_inv: IV_ASSERT
		do
			if a_invariants /= Void then
				across
					a_invariants as node
				loop
						-- Ignore modifies and decreases clauses
					if
						attached {ASSERT_B} node as l_invariant and then
						not helper.is_clause_modify (l_invariant) and then not
							helper.is_clause_decreases (l_invariant)
					then
						set_current_origin_information (l_invariant)
						process_contract_expression (l_invariant.expr, False)
						if l_invariant.tag /= Void and then l_invariant.tag.is_case_insensitive_equal_general ("assume") then
								-- Free invariant: translate as
								--	assume checks; assume free_checks; assume last_expression
							across last_safety_checks as i loop
								i.set_free (True)
								add_statement (i)
							end
							create l_inv.make (last_expression)
						else
								-- Regular invariant: translate as
								--	assert checks; assume free_checks; assert last_expression
							across last_safety_checks as i loop
								add_statement (i)
							end
							create l_inv.make (last_expression)
							l_inv.node_info.set_type ("loop_inv")
							l_inv.node_info.set_tag (l_invariant.tag)
							l_inv.node_info.set_line (l_invariant.line_number)
						end
						if not options.is_full_coverage_test_generation_enabled and not options.is_full_mcdc_test_generation_enabled then -- disable loop invariant check when generating tests
							add_statement (l_inv)
						end
					end
				end
			end
				-- Default invariants (free)
			create l_inv.make_assume (factory.function_call ("HeapSucc", <<a_pre_heap, factory.global_heap>>, types.bool))
			add_statement (l_inv)
			if options.is_ownership_enabled then
				if a_loop_frame = Void then
						-- Nothing outside routine's frame has changed compared to old(Heap)
						-- (here we have to compare to old(Heap) because the routines's frame referes to ownership domains then.
					create l_inv.make_assume (factory.writes_routine_frame (current_feature, current_type, current_implementation.procedure))
				else
						-- Nothing outside loop's frame has changed since before the loop
						-- (here we have to compare to before the loop because the loop's frame referes to ownership domains then.
					create l_inv.make_assume (factory.function_call ("same_outside", <<a_pre_heap, factory.global_heap, a_loop_frame>>, types.bool))
				end
				add_statement (l_inv)
				create l_inv.make_assume (factory.function_call ("global", <<factory.global_heap>>, types.bool))
				add_statement (l_inv)
			end
		end

mcdc_of_decision (a_expr: BYTE_NODE): ARRAYED_LIST [ARRAYED_LIST [BOOLEAN]]
			-- Process expression `a_expr'.
		local
			l_generator: E2B_MCDC_NODE_GENERATOR
			l_op, l_sequence: STRING
			l_node: E2B_MCDC_NODE
			l_test_suite_int: ARRAYED_LIST [INTEGER]
			l_test: ARRAYED_LIST [BOOLEAN]
			l_test_suite: ARRAYED_LIST [ARRAYED_LIST [BOOLEAN]]
			l_index, i: INTEGER
		do
			create l_generator.make
				-- if attached current_origin_information as coi then
				--	l_generator.set_context_line_number (coi.line)
				-- end
				-- l_generator.copy_entity_mapping (entity_mapping)
				-- l_generator.locals_map.merge (locals_map)
			a_expr.process (l_generator)

			create l_test.make (0)
			create l_test_suite.make (0)
			create l_test_suite_int.make (0)

			across l_generator.leaf_nodes as leaf loop
					-- generate independent test pair for each leaf node
				l_index := l_index + 1

				from
					l_node := leaf
				until
					not (attached l_node.parent) -- loop untill reaching the root
				loop

					l_op := l_node.parent.operator
					if l_op ~ "||" or l_op ~ "==>" then
						l_node.sibling.set_expected_value (False)
					elseif l_op ~ "&&" or l_op ~ "==" or l_op ~ "!=" then
						l_node.sibling.set_expected_value (True)
					end

						--  go to the immediate parent
					l_node := l_node.parent
				end

					-- traverse the leaf nodes to get the test
				l_test.wipe_out
				l_sequence := ""
				from
					i := 1
				until
					i > l_generator.leaf_nodes.count
				loop
					if not (i = l_index) then
						l_sequence.append (l_generator.leaf_nodes [i].expected_value.to_integer.out)
						l_test.extend (l_generator.leaf_nodes [i].expected_value)
					else
						l_sequence.append ("1")
						l_test.extend (True)
					end
					i := i + 1
				end

					-- TODO: how to use hash function to reduce the cost
				if not l_test_suite_int.has (l_sequence.to_integer) then
					l_test_suite_int.extend (l_sequence.to_integer)
					l_test_suite.extend (l_test.twin)
				end

					-- Flip the value at node l_index to get the complement pair
				l_sequence.replace_substring ("0", l_index, l_index)
				if not l_test_suite_int.has (l_sequence.to_integer) then
					l_test_suite_int.extend (l_sequence.to_integer)
					l_test [l_index] := False
					l_test_suite.extend (l_test.twin)
				end

			end
			Result := l_test_suite
		end

	process_mcdc_expression (a_expr: BYTE_NODE; a_conditions_values: ARRAYED_LIST [BOOLEAN])
			-- Process expression `a_expr'.
		local
			l_translator: E2B_MCDC_EXPRESSION_TRANSLATOR
			-- l_recur_cond: IV_FUNCTION
		do
			create l_translator.make_from_test (a_conditions_values)
			l_translator.set_context (current_feature, current_type)
			l_translator.set_context_implementation (current_implementation)
			if attached current_origin_information as coi then
				l_translator.set_context_line_number (coi.line)
			end
			l_translator.copy_entity_mapping (entity_mapping)
			l_translator.locals_map.merge (locals_map)
			l_translator.set_local_writable (local_writable)
			l_translator.set_context_readable (context_readable)
			a_expr.process (l_translator)

			across
				l_translator.side_effect as stmts
			loop
				if @ stmts.is_first and attached current_origin_information as coi then
					stmts.set_origin_information (coi)
					current_origin_information := Void
				end
				current_block.add_statement (stmts)

					-- Add a function of recursive condition
--				if options.is_full_coverage_test_generation_enabled and attached {IV_PROCEDURE_CALL} stmts as l_call and then l_call.is_recursive then
--					 create l_recur_cond.make (current_feature.feature_name + "_rec_cond", types.bool)
--					 l_recur_cond.set_body (recursive_condition_body (l_call))

--					if attached boogie_universe.procedure_named (name_translator.boogie_procedure_for_feature (current_feature, current_type)) as l_proc then
--							-- use the same set of arguments as the current feature
--							-- TODO: perform recursion inlining when generate tests for full-coverage
--						across l_proc.arguments as arg loop
--							l_recur_cond.add_argument (arg.name, arg.type)
--						end
--					end
--					boogie_universe.add_declaration (l_recur_cond)
--				end
			end
			last_expression := l_translator.last_expression
			if last_expression = Void then
				last_expression := factory.false_
			end
			locals_map.merge (l_translator.locals_map)
			create entity_mapping.make_copy (l_translator.entity_mapping)
		end


	process_expression (a_expr: BYTE_NODE)
			-- Process expression `a_expr'.
		local
			l_translator: E2B_BODY_EXPRESSION_TRANSLATOR
			l_generics: ARRAYED_LIST [TYPE_A]
			l_type: E2B_CL_TYPE_A
			l_gen_type: GEN_TYPE_A
				-- l_recur_cond: IV_FUNCTION
			l_if: IV_CONDITIONAL
			l_test_suite: ARRAYED_LIST [ARRAYED_LIST [BOOLEAN]]
			l_orig_expression: IV_EXPRESSION
			l_node: BYTE_NODE
			l_call: CALL_ACCESS_B
		do
			if not options.is_full_mcdc_test_generation_enabled then
				create l_translator.make
			else
				create {E2B_MCDC_DECISION_COLLECTOR} l_translator.make
			end

			l_node := a_expr
			l_type := current_type

			-- Handle calls to features' precursor and instance free calls.
			if attached {CALL_ACCESS_B} l_node as e and then
				attached {CL_TYPE_A} e.precursor_type as l_cl_type_a
			then
				-- Handle instance free calls to types with formal generics
				if
					e.is_instance_free and then
					attached {GEN_TYPE_A} l_cl_type_a  as l_gen_type_a and then
					l_gen_type_a.has_formal_generic
				then
					-- We need to swap the type with formals with a fully actualized type.
					-- We achieve the actualization using ANY.
					-- The actualized type must be placed in both the currently processed byte node
					-- (which is cloned to isolate this actualization for translation to boogie)
					-- and the context type for the translator.
					l_call := e.twin
					create l_generics.make (0)
					⟳ i: 1 |..| l_gen_type_a.generics.count ¦ l_generics.extend (create {CL_TYPE_A}.make (system.any_class.compiled_class.class_id)) ⟲
					l_gen_type := l_gen_type_a.duplicate_for_instantiation
					l_gen_type.set_generics (l_generics)
					l_call.set_precursor_type (l_gen_type)
					l_type := create {E2B_CL_TYPE_A}.make (l_gen_type)
					l_node := l_call
				else
					-- Set the proper context-type for calls to features' precursor
					l_type := create {E2B_CL_TYPE_A}.make (l_cl_type_a)
				end
			end


			l_translator.set_context (current_feature, l_type)
			l_translator.set_context_implementation (current_implementation)
			if attached current_origin_information as coi then
				l_translator.set_context_line_number (coi.line)
			end
			l_translator.copy_entity_mapping (entity_mapping)
			l_translator.locals_map.merge (locals_map)
			l_translator.set_local_writable (local_writable)
			l_translator.set_context_readable (context_readable)

			l_node.process (l_translator)

			l_orig_expression := l_translator.last_expression

			across
				l_translator.side_effect as stmts
			loop
				if @ stmts.is_first and attached current_origin_information as coi then
					stmts.set_origin_information (coi)
					current_origin_information := Void
				end
				current_block.add_statement (stmts)

					-- Add a function of recursive condition
--				if options.is_full_coverage_test_generation_enabled and attached {IV_PROCEDURE_CALL} stmts as l_call and then l_call.is_recursive then
--					create l_recur_cond.make (current_feature.feature_name + "_rec_cond", types.bool)
--					l_recur_cond.set_body (recursive_condition_body (l_call))

--					if attached boogie_universe.procedure_named (name_translator.boogie_procedure_for_feature (current_feature, current_type)) as l_proc then
--							-- use the same set of arguments as the current feature
--							-- TODO: perform recursion inlining when generate tests for full-coverage
--						across l_proc.arguments as arg loop
--							l_recur_cond.add_argument (arg.name, arg.type)
--						end
--					end
--					boogie_universe.add_declaration (l_recur_cond)
--				end
			end
			last_expression := l_translator.last_expression
				-- check whether the expression is a boolean

			if last_expression = Void then
				last_expression := factory.false_
			end
			locals_map.merge (l_translator.locals_map)
			create entity_mapping.make_copy (l_translator.entity_mapping)

				-- mcdc tests
				-- if not options.is_generate_minimal_counterexample_enabled and not options.mcdc_decision_exprs.is_empty then
			if not options.mcdc_decision_exprs.is_empty then
				l_test_suite := mcdc_of_decision (options.mcdc_decision_exprs.first)
				current_implementation.set_has_conditional (True)
				current_implementation.procedure.set_has_conditional (True)

				across l_test_suite as l_test loop
					process_mcdc_expression (options.mcdc_decision_exprs.first, l_test)
					create l_if.make (last_expression)
					add_statement (l_if)
					update_ghost_status (a_expr, l_if)
				end
				options.mcdc_decision_exprs.wipe_out
			end

			last_expression := l_orig_expression
		end

compute_mcdc_test_suite (a_number_of_conditions: INTEGER; decision_expr: STRING)
			-- Compute a test suite that satisfies MCDC
			-- Generate a truth table of `a_number_of_conditions' for the predicate `decision_expr'
		local
			t_table: ARRAYED_LIST [STRING]
			l_smt_file_name: STRING
		do
			t_table := init_truth_table (a_number_of_conditions)
			l_smt_file_name := "testMCDC.smt"
			t_table := compute_decision_values (l_smt_file_name, t_table, a_number_of_conditions, decision_expr)
		end

	init_truth_table (n: INTEGER): ARRAYED_LIST [STRING]
			-- Return a truth table that consists of `n' conditions
			-- Each element of `Result' is a possible combination of T/F value
		local
			l_entry, l_new_entry: STRING
			l_index, l_flip_pos: INTEGER
		do
			create Result.make (0)
			l_entry := ""; l_new_entry := ""
			across 1 |..| n as i loop
				l_entry.append_character ('T')
			end
			Result.force (create {STRING}.make_from_string (l_entry))
			Result.compare_objects

			from
				l_index := 1
			until
				l_index > Result.count
			loop
				l_entry.copy (Result [l_index])

				from
					l_flip_pos := 1
				until
					l_flip_pos > l_entry.count
				loop
					if l_entry [l_flip_pos] ~ 'T' then -- Flip each character and add the filpped string to the table
						l_entry [l_flip_pos] := 'F'
						l_new_entry.copy (l_entry)
						l_entry [l_flip_pos] := 'T'

						if not Result.has (l_new_entry) then
							Result.extend (create {STRING}.make_from_string (l_new_entry))
						end
					end
					l_flip_pos := l_flip_pos + 1
				end
				l_index := l_index + 1
			end

		end

	compute_decision_values (a_file_name: STRING_8; a_truth_table: ARRAYED_LIST [STRING]; n: INTEGER; a_decision_expr: STRING): ARRAYED_LIST [STRING]
			-- Compute T/F values for `a_decision_expr' using SMT solving
			-- `Result' is a new truth table with the computed values
		local
			smt_f: EPA_SMTLIB_FACILITY
			l_smt_content, l_dec, l_decision, l_clause, l_operator: STRING
			l_op_index: INTEGER
			l_words: LIST [STRING]
			l_is_last_parenthesis: BOOLEAN
		do
			create smt_f.make (system.test_system.project_location.out, a_file_name)
			l_smt_content := ""; l_dec := ""; l_clause := ""; l_operator := ""
			across 1 |..| n as i loop
				l_dec := l_dec + "(declare-fun " + "c" + i.out + "() Bool)%N"
			end

			across a_truth_table as entry loop
				l_clause := "(assert (and "
				across 1 |..| n as i loop
					if entry [i] ~ 'T' then
						l_clause := l_clause + "c" + i.out + " "
					else
						l_clause := l_clause + "(not c" + i.out + ") "
					end
				end
				l_clause := l_clause + "))" + ";" + entry + "%N"
				l_smt_content := l_dec + l_clause
			end

			l_decision := "c1"
			l_words := a_decision_expr.split (' ')
			l_op_index := 2

			across a_decision_expr as c loop
				if l_operator.count <= 3 then
					l_operator.append_character (c)
				else
					l_operator := ""
				end

				if c ~ '(' or c ~ ')' then
					l_decision.append_character (c)
					l_is_last_parenthesis := True
				elseif l_operator ~ "and" or l_operator ~ "or" or l_operator ~ "not" then
					l_decision := l_decision + " " + l_operator.twin + " " + "c" + l_op_index.out + " "
					l_op_index := l_op_index + 1
				end
			end
		end

	update_ghost_status (a_node: BYTE_NODE; a_statement: IV_STATEMENT)
			-- Check if `a_statement' is inside a `ghost' feature
		local
			feat: E2B_FEATURE_I
		do
			create feat.make (a_node.context.current_feature)
			if feat.is_ghost then
				a_statement.node_info.set_attribute ("status", "ghost")
			elseif feat.is_lemma then
				a_statement.node_info.set_attribute ("status", "lemma")
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
