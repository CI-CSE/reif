note
	description: "Summary description for {AFX_FIXER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_FIXER

inherit

	SHARED_WORKBENCH

	SHARED_DEBUGGER_MANAGER

	EPA_SHARED_CLASS_THEORY

	EPA_DEBUGGER_UTILITY

	AFX_SHARED_STATE_SERVER

	SHARED_EIFFEL_PARSER

	AFX_UTILITY

	EPA_COMPILATION_UTILITY

	EPA_SHARED_EQUALITY_TESTERS

	EQA_TEST_EXECUTION_MODE

	SHARED_SERVER

	AFX_PROGRAM_EXECUTION_INVARIANT_ACCESS_MODE

	AFX_SHARED_SESSION

	EPA_UTILITY

	-- ES_ADB_SHARED_INFO_CENTER

feature -- Access

	fixes: DS_ARRAYED_LIST [AFX_FIX_TO_FAULT]
			-- Fixes generated.

	features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			--

feature -- Basic operation

	integer_expressions (a_expressions: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions of type {INTEGER} from `a_expressions'.
		require
			expressions_attached: a_expressions /= Void
		local
			l_exp: EPA_EXPRESSION
		do
			create Result.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration

				if l_exp.type.is_integer then
					Result.force (l_exp)
				end

				a_expressions.forth
			end
		end

	boolean_expressions (a_expressions: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions of type {BOOLEAN} from `a_expressions'.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_EXPRESSION
		do
			create Result.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration

				if l_exp.type.is_boolean then
					Result.force (l_exp)
				end

				a_expressions.forth
			end
		end

	reference_expressions (a_expressions: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions returning references from `a_expressions'.
		require
			expressions_attached: a_expressions /= VOid
		local
			l_exp: EPA_EXPRESSION
			l_type: TYPE_A
		do
			create Result.make_equal (a_expressions.count + 1)

			from a_expressions.start
			until a_expressions.after
			loop
				l_exp := a_expressions.item_for_iteration
				l_type := l_exp.type
				if not l_type.is_void and then not l_type.is_basic then
					Result.force (l_exp)
				end
				a_expressions.forth
			end
		end

	derived_boolean_expressions_from_invariants (a_invariants: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- Derived program expressions from Daikon invariants
		local
			l_boolean_expressions, l_integer_expressions, l_reference_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_boolean_count, l_integer_count, l_reference_count: INTEGER
			l_context_class, l_written_class: CLASS_C
			l_context_feature: FEATURE_I
				-- l_ref_aspect: AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON
			l_bool_aspect, l_bool_aspect_neg: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
			-- l_int_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
		do
			create Result.make (0)
--			l_boolean_expressions := boolean_expressions (a_invariants)
--			l_boolean_count := l_boolean_expressions.count
--			l_integer_expressions := integer_expressions (a_invariants)
--			l_integer_count := l_integer_expressions.count
--			l_reference_expressions := reference_expressions (a_invariants)
--			l_reference_count := l_reference_expressions.count

			l_context_class := session.feature_under_proof.context_class
			l_context_feature := session.feature_under_proof.feature_
			l_written_class := session.feature_under_proof.written_class

			across a_invariants as expr loop
				create l_bool_aspect.make_boolean_relation (l_context_class, l_context_feature, l_written_class, expr.item, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_null)
				Result.force (l_bool_aspect)
					-- create l_aspect_neg.make_boolean_relation (l_context_class, l_context_feature, l_written_class, expr, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)
					-- Result.force (l_bool_aspect_neg)
			end
		end

	derived_boolean_expressions_from_negation_of_invariants (a_invariants: EPA_HASH_SET [EPA_EXPRESSION]): EPA_HASH_SET [EPA_EXPRESSION]
			-- Derived program expressions from Daikon invariants
		local
			l_boolean_expressions, l_integer_expressions, l_reference_expressions: EPA_HASH_SET [EPA_EXPRESSION]
			l_boolean_count, l_integer_count, l_reference_count: INTEGER
			l_context_class, l_written_class: CLASS_C
			l_context_feature: FEATURE_I
				-- l_ref_aspect: AFX_PROGRAM_STATE_ASPECT_REFERENCE_COMPARISON
			l_bool_aspect, l_bool_aspect_neg: AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION
			-- l_int_aspect: AFX_PROGRAM_STATE_ASPECT_INTEGER_COMPARISON
		do
			create Result.make (0)
--			l_boolean_expressions := boolean_expressions (a_invariants)
--			l_boolean_count := l_boolean_expressions.count
--			l_integer_expressions := integer_expressions (a_invariants)
--			l_integer_count := l_integer_expressions.count
--			l_reference_expressions := reference_expressions (a_invariants)
--			l_reference_count := l_reference_expressions.count

			l_context_class := session.feature_under_proof.context_class
			l_context_feature := session.feature_under_proof.feature_
			l_written_class := session.feature_under_proof.written_class
			across a_invariants as expr loop
				create l_bool_aspect.make_boolean_relation (l_context_class, l_context_feature, l_written_class, expr.item, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)
				Result.force (l_bool_aspect)
					-- create l_aspect_neg.make_boolean_relation (l_context_class, l_context_feature, l_written_class, expr, Void, {AFX_PROGRAM_STATE_ASPECT_BOOLEAN_RELATION}.Operator_boolean_negation)
					-- Result.force (l_bool_aspect_neg)
			end
		end


	proof_based_fixing
		-- Fixing process based on proof
		local
			l_components: LIST [STRING]
			l_target_class, l_target_feature, l_failure_msg: STRING
			l_exception_code, l_line_number: INTEGER
			l_proof_failure: AFX_PROOF_FAILURE
			l_ce_traces_before_fixing: AFX_CE_TRACE_REPOSITORY
			l_invariant_detecter: AFX_INVARIANT_DETECTER
			l_fixing_targets: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_res_invariants: EPA_HASH_SET [EPA_EXPRESSION]
			l_fixing_target: AFX_FIXING_TARGET
			l_code_fixes, l_contract_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			l_candidate_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			l_start_id: INTEGER
		do
			l_components := session.config.fault_signature_id.split ('.')
				if not l_components.is_empty and then l_components.count >= 5 then
						-- Get the info of proof failure
					l_target_class := l_components [1]
					l_target_feature := l_components [2]
					l_exception_code := l_components [3].to_integer
					l_line_number := l_components [4].to_integer
					l_failure_msg := l_components [5]
					create l_proof_failure.make (l_target_class, l_target_feature, l_exception_code, l_line_number, l_failure_msg)
				end

				l_ce_traces_before_fixing := collect_ce_traces (l_proof_failure)

				create l_invariant_detecter
				l_invariant_detecter.detect (session.config.is_proof_based_fixing, l_ce_traces_before_fixing.ce_traces)
				print ("invariants size: " + l_invariant_detecter.invariants_from_ce_cell.item.count.out + "%N")
				l_res_invariants := derived_boolean_expressions_from_invariants (l_invariant_detecter.invariants_from_ce_cell.item.first.first.expressions)
				-- TODO Li: try other states

				create l_fixing_targets.make (0)
				create l_candidate_fixes.make (0)

				across l_res_invariants as inv loop
					create l_fixing_target.make (inv.item, 1, 1.0) -- use the initial ce invariants as fixing target
					l_fixing_targets.force (l_fixing_target, l_fixing_targets.count + 1)
				end

				if config.is_fixing_implementation then
					l_code_fixes := generate_implementation_fixes (l_fixing_targets)
					l_candidate_fixes.append_last (l_code_fixes)
				end

				if config.is_fixing_contract then
					-- create l_feature_to_relax.make_from_feature_with_context_class (session.feature_under_proof)
					-- l_contract_fixes := generate_contract_fixes (l_traces_before_fixing_twin, l_traces_after_relaxing)

					-- create l_contract_fixes.make_default
					if not l_candidate_fixes.is_empty then
						l_start_id := l_candidate_fixes.last.id
					else
						l_start_id := 1
					end
					l_contract_fixes := generate_contract_fixes_with_ce_invariants (derived_boolean_expressions_from_negation_of_invariants (l_invariant_detecter.invariants_from_ce_cell.item.first.first.expressions), l_proof_failure, l_start_id)
					l_candidate_fixes.append_last (l_contract_fixes)
				end

				fixes.append_last (validate_fixes_with_proof (l_ce_traces_before_fixing, l_candidate_fixes))
				-- TODO Li: sort_proof_fixes

					-- TODO:
					-- l_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FEATURE]
					--	l_fix: AFX_CONTRACT_FIX_TO_FEATURE

					-- if not l_contracts_to_add.is_empty then
					--	create l_c_fix.make (session.feature_under_proof, l_contracts_to_add, l_contracts_to_remove, Void, Void)
					-- 	l_c_fixes.force_last (l_c_fix)
					--end


					-- if not l_contracts_to_remove.is_empty then
					--	create l_c_fix.make (session.feature_under_proof, Void, Void, l_contracts_to_add, l_contracts_to_remove) -- remove old postconditions and add new implication clauses
					--	l_c_fixes.force_last (l_c_fix)
					-- end

					-- sort_contract_fixes (l_contract_fixes)
					-- fixes.append_last (l_contract_fixes)

		end

		test_based_fixing
			-- Fixing process based on testing
		local
			l_fixing_target: AFX_FIXING_TARGET
			l_fixing_targets: DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			l_traces_before_fixing, l_traces_before_fixing_twin, l_traces_after_relaxing, l_traces_for_validation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_feature_to_relax: AFX_FEATURE_TO_MONITOR
			l_features_to_relax, l_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_index: INTEGER
			l_contract_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT]
			l_code_fixes, l_valid_code_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			l_exception_code: INTEGER
		do
			reproduce_failure
					-- 	 Replace recipient feature with 'session.exception_from_execution.recipient_feature_with_context',
					-- 	 because the latter have extra expressions to monitor during trace collection.
				from
					l_features_to_monitor := features_to_monitor
					l_features_to_monitor.start
				until
					l_features_to_monitor.after
				loop
					if l_features_to_monitor.item_for_iteration.qualified_feature_name ~ session.exception_from_execution.recipient_feature_with_context.qualified_feature_name then
						l_features_to_monitor.item_for_iteration.add_extra_expressions (session.exception_from_execution.recipient_feature_with_context.extra_expressions)
					end
					l_features_to_monitor.forth
				end

				l_traces_before_fixing := collect_behavior_of_regular_tests
				l_traces_before_fixing_twin := l_traces_before_fixing.twin

				if not config.is_fixing_implementation then
					if config.is_fixing_implementation then
						l_fixing_targets := localize_faulty_targets (l_traces_before_fixing)
						if config.should_log_for_debugging then
								--	 Log at most the first 100 fixing targets.
							event_actions.notify_on_supplemental_notification_issued ("LOGGING FIXING TARGETS")
							from
								l_fixing_targets.start
								l_index := 0
							until
								l_index >= 100 or l_fixing_targets.after
							loop
								event_actions.notify_on_supplemental_notification_issued (l_fixing_targets.item_for_iteration.debug_output)
								l_fixing_targets.forth
								l_index := l_index + 1
							end
						end

						l_code_fixes := generate_implementation_fixes (l_fixing_targets)
						if config.should_log_for_debugging then
							event_actions.notify_on_supplemental_notification_issued ("LOGGING ALL CODE FIXES")
							from l_code_fixes.start
							until
								l_code_fixes.after
							loop
								event_actions.notify_on_supplemental_notification_issued (l_code_fixes.item_for_iteration.out)
								l_code_fixes.forth
							end
						end

						l_valid_code_fixes := validate_implementation_fixes (l_traces_before_fixing, l_code_fixes)

						if config.should_log_for_debugging then
							event_actions.notify_on_supplemental_notification_issued ("LOGGING VALID CODE FIXES")
							from l_valid_code_fixes.start
							until
								l_valid_code_fixes.after
							loop
								event_actions.notify_on_supplemental_notification_issued (l_valid_code_fixes.item_for_iteration.out)
								l_valid_code_fixes.forth
							end
						end
						fixes.append_last (l_valid_code_fixes)
					end

					if attached session.exception_from_execution then
						l_exception_code := session.exception_from_execution.exception_code
					end
					if config.is_fixing_contract and then (l_exception_code = 3 or l_exception_code = 4) then
						create l_feature_to_relax.make_from_feature_with_context_class (session.exception_from_execution.exception_feature_with_context)
						l_feature_to_relax.set_monitor_contracts (True)
						l_feature_to_relax.set_monitor_body (False)
						l_traces_after_relaxing := collect_behavior_of_relaxed_tests (l_feature_to_relax)

						l_contract_fixes := generate_contract_fixes (l_traces_before_fixing_twin, l_traces_after_relaxing)
						if config.should_log_for_debugging then
							event_actions.notify_on_supplemental_notification_issued ("LOGGING CONTRACT FIXES")
							from l_contract_fixes.start
							until
								l_contract_fixes.after
							loop
								event_actions.notify_on_supplemental_notification_issued (l_contract_fixes.item_for_iteration.out)
								l_contract_fixes.forth
							end
						end
						validate_contract_fixes (l_contract_fixes)
						sort_contract_fixes (l_contract_fixes)
						fixes.append_last (l_contract_fixes)
					end
				end
		end

	execute
			-- Run fixing process
		do
			disable_catcall_warnings
			create fixes.make_equal (30)

				-- HACK: force re-compiling the root class by "touch"ing it, otherwise expression evaluation might fail.
			(create {PLAIN_TEXT_FILE}.make_with_name (root_class_of_system.file_name)).touch
			compile_project (eiffel_project, True)

			session.initialize_logging
			session.start
			event_actions.notify_on_session_started

			if session.config.is_proof_based_fixing then
					-- l_failures := collect_proof_failures (session.proof_failure_directory)
					-- TODO: get a list of AFX_TARGET based on the passed_block_id?
				proof_based_fixing
			else
				test_based_fixing
			end

			rank_fixes
			event_actions.notify_on_session_terminated
			session.clean_up
		end

feature {NONE} -- Implementation

	reproduce_failure
			--
		local
			l_reproducer: AFX_FAILURE_REPRODUCER
		do
			create l_reproducer
			l_reproducer.reproduce (False)
			features_to_monitor := l_reproducer.features_to_monitor
		end

	collect_ce_traces (a_failure: AFX_PROOF_FAILURE): AFX_CE_TRACE_REPOSITORY
		local
			l_files_path: STRING
			l_ce_traces_of_failure: AFX_CE_TRACES_OF_FAILURE
			l_class: CLASS_C
			l_routine: FEATURE_I
			daikon_ce_trace_printer: AFX_CE_TRACE_TO_DAIKON_PRINTER
			l_feature_under_proof: AFX_FEATURE_TO_MONITOR
		do
				-- TODO: handle the cases of multiple failures using loop
			l_class := first_class_starts_with_name (a_failure.target_class_name)
			l_routine := l_class.feature_named (a_failure.target_routine_name)
			l_files_path := session.ce_traces_directory (a_failure).out

			create l_ce_traces_of_failure.make (l_class, l_routine, l_files_path) -- create a folder to store traces for each failed feature

			create l_feature_under_proof.make (l_routine, l_class)
			l_feature_under_proof.set_monitor_body (true)
			l_feature_under_proof.set_monitor_contracts (true)
			session.set_feature_under_proof (l_feature_under_proof)
			create features_to_monitor.make_from_array (<<l_feature_under_proof>>)

			create Result
			Result.ce_traces.wipe_out
			Result.register_ce_traces (l_ce_traces_of_failure)
			Result := Result.derived_compound_repository (features_to_monitor, True)
		end

	collect_behavior_of_regular_tests: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			--
		local
			l_collector: AFX_TRACE_COLLECTOR
		do
			event_actions.notify_on_test_case_analysis_started (session.number_of_test_cases_for_fixing)

			create l_collector
			l_collector.set_monitor_mode (l_collector.mode_analyze_tc)
			l_collector.set_features_to_monitor (features_to_monitor)
			l_collector.collect (config.is_fixing_contract)
			Result := l_collector.trace_repository.derived_compound_repository (features_to_monitor, True)

			event_actions.notify_on_test_case_analysis_finished
		end

	localize_faulty_targets (a_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY): DS_ARRAYED_LIST [AFX_FIXING_TARGET]
			-- Compute suspiciousness values of fixing targets.
		local
			l_trace_analyzer: AFX_EXECUTION_TRACE_ANALYZER
			l_feature_cursor: DS_ARRAYED_LIST_CURSOR [AFX_FEATURE_TO_MONITOR]
			l_feature: AFX_FEATURE_TO_MONITOR
			l_bpt_interval: INTEGER_INTERVAL
			l_bpts: DS_HASH_SET [INTEGER]

			l_recipient: AFX_FEATURE_TO_MONITOR
			l_ranker: AFX_PROGRAM_STATE_RANKER
			l_invariant_detecter: AFX_INVARIANT_DETECTER
		do
			print ("number of passing tests" + a_trace_repository.number_of_passing_traces.out + "%N")
			print ("number of failing tests" + a_trace_repository.number_of_failing_traces.out + "%N")
				-- create l_invariant_detecter
				-- l_invariant_detecter.detect -- (session.config.is_fixing_contract)

			if session.should_continue then
				progression_monitor.set_progression (progression_monitor.progression_fault_localization_start)
				event_actions.notify_on_implementation_fix_generation_started

				create l_trace_analyzer
				from
					l_recipient := session.exception_from_execution.recipient_feature_with_context
					l_feature_cursor := features_to_monitor.new_cursor
					l_feature_cursor.start
				until
					l_feature_cursor.after
				loop
					l_feature := l_feature_cursor.item

					if l_recipient.is_about_same_feature (l_feature) then -- what is the difference between recipient and feature to monitor?
						l_bpt_interval := l_feature.first_breakpoint_in_body |..| l_feature.last_breakpoint_in_body
						create l_bpts.make_equal (l_bpt_interval.count)
						l_bpt_interval.do_all (agent l_bpts.force)
						l_trace_analyzer.add_breakpoints_for_feature (l_bpts, l_feature)
					end

					l_feature_cursor.forth
				end

				l_trace_analyzer.collect_statistics_from_trace_repository (a_trace_repository, {AFX_EXECUTION_TRACE_STATISTICS_UPDATE_MODE}.Update_mode_merge_presence)

				create l_ranker.make (session.exception_from_execution)
				l_ranker.compute_suspiciousness_ranks (l_trace_analyzer.statistics_from_passing, l_trace_analyzer.statistics_from_failing)
				Result := l_ranker.fixing_target_list

				progression_monitor.set_progression (progression_monitor.progression_fault_localization_end)
			else
				Result := Void
			end
		end

	generate_implementation_fixes (a_fixing_target_list: DS_ARRAYED_LIST [AFX_FIXING_TARGET]): DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- <Precursor>
		local
			l_generator: AFX_RANDOM_BASED_FIX_GENERATOR
			l_fix_texts: DS_HASH_SET [STRING]
			l_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			l_fix_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CODE_FIX_TO_FAULT]
			l_fix: AFX_CODE_FIX_TO_FAULT
			l_text: STRING
		do
			-- print ("AFX_FIXER.generate_implementation_fixes %N")
			create Result.make_equal (1)
			if session.should_continue then
				progression_monitor.set_progression (progression_monitor.progression_fix_generation_start)

					-- Generation
				create l_generator
				l_generator.set_fixing_target_list (a_fixing_target_list)
				l_generator.generate

				Result := l_generator.fixes

				across l_generator.fixes as f loop
					-- print ("fix: " + f.item.fixed_feature_text + "%N")
				end

				event_actions.notify_on_implementation_fix_generation_finished (Result)
				progression_monitor.set_progression (progression_monitor.progression_fix_generation_end)
			end
		end

	generate_contract_fixes_with_ce_invariants (a_contracts: EPA_HASH_SET [EPA_EXPRESSION]; a_proof_failure: AFX_PROOF_FAILURE; a_last_fix_id: INTEGER): DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
			-- Generate candidate contract fixes based on ce invariants
			-- Modify contracts of `a_feature' based on two strategy
			-- 1) strengthening precondition by adding negation of counterexample properties
			-- 2) weakening postconditions using implication clauses
		local
			l_fix_validator: AFX_PROOF_BASED_FIX_VALIDATOR
			l_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CODE_FIX_TO_FAULT]
			l_feature_contract_modifier: EPA_FEATURE_CONTRACT_MODIFIER_FOR_FAILURE
			l_feature_index: INTEGER
			l_text: STRING
			l_fixing_target: AFX_FIXING_TARGET
		do
			create Result.make (0)
			l_feature_index := a_last_fix_id
			if session.should_continue then
				-- TODO Li: recover event_actions.notify_on_contract_fix_validation_started (a_contract_fixes)

				create l_feature_contract_modifier.make (session.feature_under_proof)

				across a_contracts as c loop
					l_feature_index := l_feature_index + 1
					l_text := l_feature_contract_modifier.feature_text_with_strengthened_precondition (c.item, l_feature_index)
					create l_fixing_target.make (c.item, 1, 1.0)

					Result.force_last (create {AFX_CODE_FIX_TO_FAULT}.make (session.feature_under_proof, l_fixing_target, l_text, 1))

					if a_proof_failure.exception_code = {EXCEP_CONST}.postcondition or a_proof_failure.exception_code = {EXCEP_CONST}.class_invariant then
						l_feature_index := l_feature_index + 1
						l_text := l_feature_contract_modifier.feature_text_with_weakened_postcondition (c.item, a_proof_failure.failure_message, l_feature_index)
						Result.force_last (create {AFX_CODE_FIX_TO_FAULT}.make (session.feature_under_proof, l_fixing_target, l_text, 1))
					end
		 		-- l_feature_contract_modifier.modify_contracts_for_feature (session.feature_under_proof, a_contracts, a_proof_failure.failure_message)
				-- make (a_feature: AFX_FEATURE_TO_MONITOR; a_fixing_target: like fixing_target; a_fixed_body_text: STRING; a_scheme_type: INTEGER)
				end
				-- TODO Li: recover l_feature_contract_modifier.undo_last_operation
				-- compile_project (Eiffel_project, True)

				-- event_actions.notify_on_contract_fix_validation_finished (a_contract_fixes)
			end
		end

	validate_fixes_with_proof (a_trace_repository: AFX_CE_TRACE_REPOSITORY; l_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]): DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
		local
			l_validator: AFX_PROOF_BASED_FIX_VALIDATOR
		do
			create Result.make_equal (1)
			if session.should_continue then
				create l_validator.make (a_trace_repository, l_fixes)
				progression_monitor.set_progression (progression_monitor.progression_fix_validation_start)
				event_actions.notify_on_implementation_fix_validation_started (l_validator.fixes)

				l_validator.validate
				Result := l_validator.valid_fixes

				event_actions.notify_on_implementation_fix_validation_finished (l_validator.valid_fixes)
				progression_monitor.set_progression (progression_monitor.progression_fix_validation_end)
			end
		end

	validate_implementation_fixes (a_trace_repository: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; l_fixes: DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]): DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
		local
			l_validator: AFX_FIX_VALIDATOR_NEW
		do
			create Result.make_equal (1)
			if session.should_continue then
				create l_validator.make (a_trace_repository, l_fixes)
				progression_monitor.set_progression (progression_monitor.progression_fix_validation_start)
				event_actions.notify_on_implementation_fix_validation_started (l_validator.fixes)

				l_validator.validate
				Result := l_validator.valid_fixes

				event_actions.notify_on_implementation_fix_validation_finished (l_validator.valid_fixes)
				progression_monitor.set_progression (progression_monitor.progression_fix_validation_end)
			end
		end

	collect_behavior_of_relaxed_tests (a_feature_to_relax: AFX_FEATURE_TO_MONITOR): AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			--
		local
			l_features: DS_HASH_SET [AFX_FEATURE_TO_MONITOR]
			l_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]
			l_feature_table: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
			l_feature_contract_remover: EPA_FEATURE_CONTRACT_REMOVER
			l_collector: AFX_TRACE_COLLECTOR
		do
			event_actions.notify_on_weakest_contract_inference_started (a_feature_to_relax)

				-- Relax feature contracts
			create l_features.make_equal (1)
			l_features.force (a_feature_to_relax)
			create l_feature_table.make_equal (2)
			l_feature_table.force (l_features, True)
			l_feature_table.force (l_features.twin, False)
			create l_feature_contract_remover
			l_feature_contract_remover.remove_contracts_of_features (l_feature_table)
			compile_project (Eiffel_project, True)

				-- Monitor behavior of feature with relaxed contracts
			create l_features_to_monitor.make_equal (1)
			l_features_to_monitor.force_last (a_feature_to_relax)
			create l_collector
			l_collector.set_monitor_mode (l_collector.mode_analyze_relaxed_tc)
			l_collector.set_features_to_monitor (l_features_to_monitor)
			l_collector.collect (True)
			if l_collector.trace_repository /= Void then
				Result := l_collector.trace_repository.derived_compound_repository (l_features_to_monitor, True)
			else
				create Result.make_default
			end
			l_feature_contract_remover.undo_last_removal
			compile_project (Eiffel_project, True)

			event_actions.notify_on_weakest_contract_inference_finished (a_feature_to_relax)
		end

	generate_contract_fixes (a_traces_before_fixing, a_traces_after_relaxing: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY): DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT]
			--
		local
			l_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_ACROSS_FEATURES]
			l_strengthener: AFX_TRACE_BASED_CONTRACT_STRENGTHENER
			l_weakener: AFX_TRACE_BASED_CONTRACT_WEAKENER
			l_regular_traces, l_relaxed_traces, l_failing_regular_traces, l_passing_regular_traces, l_all_traces: DS_ARRAYED_LIST [AFX_PROGRAM_EXECUTION_TRACE]

			l_fix: AFX_CONTRACT_FIX_ACROSS_FEATURES
			l_new_fix: AFX_CONTRACT_FIX_TO_FAULT
		do
			create Result.make_equal (64)
			if session.should_continue then
				event_actions.notify_on_contract_fix_generation_started

				create l_regular_traces.make_equal (a_traces_before_fixing.count + 1)
				a_traces_before_fixing.do_all (agent l_regular_traces.force_last)
				create l_relaxed_traces.make_equal (a_traces_after_relaxing.count + 1)
				a_traces_after_relaxing.do_all (agent l_relaxed_traces.force_last)
				create l_passing_regular_traces.make_equal (a_traces_before_fixing.count + 1)
				l_regular_traces.do_if (agent l_passing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_passing)
				create l_failing_regular_traces.make_equal (a_traces_before_fixing.count + 1)
				l_regular_traces.do_if (agent l_failing_regular_traces.force_last, agent {AFX_PROGRAM_EXECUTION_TRACE}.is_failing)
				create l_all_traces.make_equal (l_regular_traces.count + l_relaxed_traces.count + 1)
				l_regular_traces.do_all (agent l_all_traces.force_last)
				l_relaxed_traces.do_all (agent l_all_traces.force_last)

					-- Prefer weakening
				create l_weakener
				l_weakener.fix_traces (l_regular_traces, l_relaxed_traces, features_to_monitor)
				Result.append_last (l_weakener.last_contract_fixes)

				create l_strengthener
				l_strengthener.fix_traces (l_passing_regular_traces, l_failing_regular_traces, l_relaxed_traces, features_to_monitor)
				Result.append_last (l_strengthener.last_contract_fixes)

				event_actions.notify_on_contract_fix_generation_finished (Result)
			end
		end

	validate_contract_fixes (a_contract_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			--
		local
			l_features_to_weaken: DS_HASH_SET [AFX_FEATURE_TO_MONITOR]
			l_feature_table: DS_HASH_TABLE [DS_HASH_SET [EPA_FEATURE_WITH_CONTEXT_CLASS], BOOLEAN]
			l_fix_validator: AFX_TEST_CASE_MONITOR_FOR_FIX_VALIDATION
			l_collector: AFX_TRACE_COLLECTOR
			l_trace_for_validation: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY
			l_cursor: DS_ARRAYED_LIST_CURSOR [AFX_CONTRACT_FIX_TO_FAULT]
			l_feature_contract_remover: EPA_FEATURE_CONTRACT_REMOVER
			l_index: INTEGER
		do
			if session.should_continue then
				event_actions.notify_on_contract_fix_validation_started (a_contract_fixes)

					-- Disable the preconditions of `features_to_monitor'.
				create l_features_to_weaken.make_equal (10)
				features_to_monitor.do_all (agent l_features_to_weaken.force_last)
				create l_feature_table.make_equal (2)
				l_feature_table.force (l_features_to_weaken, True)
				create l_feature_contract_remover
				l_feature_contract_remover.remove_contracts_of_features (l_feature_table)
				compile_project (Eiffel_project, True)

					-- Run all available tests and collect the traces.
				create l_collector
				l_collector.set_monitor_mode (l_collector.mode_analyze_all_tc)
				l_collector.set_features_to_monitor (features_to_monitor)
				l_collector.collect (True)
				l_trace_for_validation := l_collector.trace_repository.derived_compound_repository (features_to_monitor, True)

					-- Restore the preconditions.
				l_feature_contract_remover.undo_last_removal
				compile_project (Eiffel_project, True)

					-- Validate fixes w.r.t. the observed traces.
				a_contract_fixes.do_all (
					agent (a_fix: AFX_CONTRACT_FIX_TO_FAULT; a_traces: AFX_PROGRAM_EXECUTION_TRACE_REPOSITORY; a_all_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR])
						do a_fix.compute_ranking_wrt_trace_repository (a_traces, a_all_features_to_monitor) end (?, l_trace_for_validation, features_to_monitor))

					-- Remove invalid fixes, keep at most config.max_valid_fix_number valid fixes.
				from
					l_cursor := a_contract_fixes.new_cursor
					l_cursor.start
					l_index := 0
				until
					l_cursor.after
				loop
					if l_cursor.item.ranking >= {AFX_CONTRACT_FIX_TO_FAULT}.Ranking_weight_for_failing or l_index >= session.config.max_valid_fix_number.to_integer_32 then
						a_contract_fixes.remove_at_cursor (l_cursor)
					else
						l_cursor.forth
						l_index := l_index + 1
					end
				end

				event_actions.notify_on_contract_fix_validation_finished (a_contract_fixes)
			end
		end

	sort_contract_fixes (a_contract_fixes: DS_ARRAYED_LIST [AFX_CONTRACT_FIX_TO_FAULT])
			--
		local
			l_sorter: DS_QUICK_SORTER [AFX_CONTRACT_FIX_TO_FAULT]
		do
			create l_sorter.make (create {AGENT_BASED_EQUALITY_TESTER [AFX_CONTRACT_FIX_TO_FAULT]}.make (
					agent (f1, f2: AFX_CONTRACT_FIX_TO_FAULT): BOOLEAN
						do
							Result := f1.ranking <= f2.ranking
						end (?, ?)))
			l_sorter.sort (a_contract_fixes)
		end

	rank_fixes
			--
		do
			event_actions.notify_on_fix_ranking_started (fixes)

			event_actions.notify_on_fix_ranking_finished (fixes)
		end

	disable_catcall_warnings
			-- Disable catcall console and debugger warnings.
		external
			"C inline"
		alias
			"[
				extern int catcall_detection_mode;
				catcall_detection_mode = 0;
			]"
		end

end
