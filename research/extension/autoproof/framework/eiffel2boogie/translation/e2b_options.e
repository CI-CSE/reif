note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

frozen class
	E2B_OPTIONS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize default options.
		do
			is_two_step_verification_enabled := False
			is_inlining_enabled := True
			is_automatic_inlining_enabled := False
			is_automatic_loop_unrolling_enabled := False
			is_sound_loop_unrolling_enabled := True
			is_postcondition_predicate_enabled := False
			is_checking_overflow := False

			is_generating_triggers := False
			is_triggering_on_arithmetic := False
			is_arithmetic_extracted := False
			is_inv_check_independent := True
			is_ignoring_nonvariant := False

			is_ownership_enabled := True
			is_ownership_defaults_enabled := True

			loop_unrolling_depth := 5 -- A  value applicable in most cases based on the priliminary evaluation
			max_recursive_inlining_depth := 4
			number_of_iteration_for_fixing := 20

			is_postcondition_mutation_enabled := False
			is_coupled_mutations_enabled := True
			is_aging_enabled := False
			is_uncoupled_mutations_enabled := False

			is_trace_enabled := True

			is_generating_trivial_loop_variants := True

			is_bulk_verification_enabled := True
			max_parallel_boogies := 3

			is_print_time := True

			create model_files.make
			create init_states_of_counterexamples.make
			create uncovered_branch.make (0)
			create failures_for_fix.make (0)
			create potential_fixes_names.make (0)
			create valid_fixes.make (0)
			create mcdc_decision_exprs.make (0)
		end

feature -- Inlining verification step

	is_two_step_verification_enabled: BOOLEAN
			-- Is a verification with inlining done in case of failed verifications?

	set_two_step_verification_enabled (a_value: BOOLEAN)
			-- Set `is_two_step_verification_enabled' to `a_value'.
		do
			is_two_step_verification_enabled := a_value
		end

feature -- Generation of full-coverage tests

	is_full_coverage_test_generation_enabled: BOOLEAN
			-- Is generating tests for full coverage enabled?

	set_full_coverage_test_generation_enabled (a_value: BOOLEAN)
			-- Set `is_full_coverage_test_generation_enabled' to `a_value'.
		do
			is_full_coverage_test_generation_enabled := a_value
		end

	is_full_mcdc_test_generation_enabled: BOOLEAN
			-- Is generating tests for full coverage enabled?

	set_full_mcdc_test_generation_enabled (a_value: BOOLEAN)
			-- Set `is_full_coverage_test_generation_enabled' to `a_value'.
		do
			is_full_mcdc_test_generation_enabled := a_value
			set_full_coverage_test_generation_enabled (a_value)
		end

	mcdc_decision_exprs: ARRAYED_LIST [BYTE_NODE]
			-- List of decision expressions to be processed

	last_mcdc_decision_expr: STRING
			-- Last processed decision expression for MCDC

	uncovered_branch: HASH_TABLE [TUPLE [class_name: IMMUTABLE_STRING_32; line_number: INTEGER], INTEGER]
			-- Uncovered branches in the latest test generation run

feature -- Generate fixes from counterexamples

	is_generate_fix_enabled: BOOLEAN
			-- Is generating fix enabled?

	set_generate_fix_enabled (a_value: BOOLEAN)
			-- Set `is_generate_fix_enabled' to `a_value'.
		do
			is_generate_fix_enabled := a_value
		end

	ce_traces: HASH_TABLE [LINKED_LIST[E2B_CE_TRACE_OF_ROUTINE], STRING_32]
			-- Collection of ce traces
		once
			create Result.make (0)
		end

	fix_elements: LINKED_LIST [E2B_FIX_ELEMENT]
			-- Collection of fix elements
		once
			create Result.make
		end

	fix_message: STRING_32
			-- Message for possible fix

	fix_start_time: DT_TIME


	set_fix_start_time (a_fix_start_time: DT_TIME)
			-- Set `fix_start_time' to `a_fix_start_time' -- TODO Li: remove this feature
		do
			fix_start_time := a_fix_start_time
		end

	set_fix_message (a_fix_message: STRING_32)
			-- Set `fix_message' to `a_fix_message'
		do
			fix_message := a_fix_message
		end

	ce_states: LINKED_LIST [E2B_CE_STATE_OF_ROUTINE]
			-- Counterexample states collected for generation of fixes
		once
			create Result.make
		end

	current_ce_init_state: E2B_CE_STATE_OF_ROUTINE
			-- Initial state of currently targeted counterexample (new or minimal counterexample)

	fix_preconditions: LINKED_LIST [STRING]
			-- Collection of precondition for program fixes
		once
			create Result.make
		end

	last_candidate_fix: STRING
			-- Last candidate fix

	set_last_candidate_fix (a_fix: STRING)
			-- Set `last_candidate_fix' to `a_fix'
		do
			last_candidate_fix := a_fix
		end

	current_candidate_fix: STRING
			-- Last candidate fix

	set_current_candidate_fix (a_fix: STRING)
			-- Set `current_candidate_fix' to `a_fix'
		do
			current_candidate_fix := a_fix
		end

feature -- Generate tests from proof failures

		-- last_verified_stone: detachable CLASSI_STONE
		-- The stone that is verified in the last run of verification

	last_result: detachable E2B_RESULT
			-- Last generated result.

	set_last_result (a_last_result: E2B_RESULT)
			-- Set `last_result' to `a_last_result'.
		do
			last_result := a_last_result
		end

	set_current_init_state (a_current_ce_init_state: E2B_CE_STATE_OF_ROUTINE)
			-- Set `current_ce_init_state' to `a_current_ce_init_state'.
		do
			current_ce_init_state := a_current_ce_init_state
		end

		-- last_input: detachable E2B_TRANSLATOR_INPUT
		-- Input for translator in the last verification run.

	is_generate_new_counterexample_enabled: BOOLEAN
			-- Is generating new counterexample enabled?

	set_generate_new_counterexample_enabled (a_value: BOOLEAN)
			-- Set `is_generate_new_counterexample_enabled' to `a_value'.
		do
			is_generate_new_counterexample_enabled := a_value
		end

	is_generate_minimal_counterexample_enabled: BOOLEAN
			-- Is generating minimal counterexample enabled?

	set_generate_minimal_counterexample_enabled (a_value: BOOLEAN)
			-- Set `is_generate_minimal_counterexample_enabled' to `a_value'.
		do
			is_generate_minimal_counterexample_enabled := a_value
		end

	is_minimization_finished: BOOLEAN
			-- Is minimization finished?

	set_is_minimization_finished (a_value: BOOLEAN)
			-- Set `is_minimization_finished' to `a_value'
		do
			is_minimization_finished := a_value
		end

	minimization_tolerance: INTEGER
			-- Tolerance used in minimization algorithm

	minimization_iteration_bound: INTEGER
			-- Maximum number of iterations allowed in minimization algorithm

	target_feature: detachable E2B_FEATURE_I
			-- Target feature for minimization

	target_class: detachable E2B_CLASS_C
			-- Target class for minimization

	failures_for_fix: ARRAYED_LIST [E2B_FAILED_VERIFICATION]
			-- Target features for fixing

	potential_fixes_names: ARRAYED_LIST [STRING]
			-- Names of features of potential fixes

	valid_fixes: ARRAYED_LIST [STRING]
			-- Names of features of valid fixes

	target_error_index: INTEGER
			-- Index of error in the failed verification

	is_same_result: BOOLEAN
			-- Is the verification result the same as the previous run?

	set_is_same_result (a_is_same_result: BOOLEAN)
			-- Set `is_same_result' to `a_is_same_result'
		do
			is_same_result := a_is_same_result
		end

	new_ce_message: READABLE_STRING_32
			-- New message for counterexample

	set_new_ce_message (a_ce_message: READABLE_STRING_32)
			-- Set `new_ce_message' to `a_ce_message'
		do
			new_ce_message := a_ce_message
		end

	set_target_feature (a_feature: like target_feature)
			-- Set `target_feature' to `a_feature'
		do
			target_feature := a_feature
		end

	set_target_class (a_class: like target_class)
			-- Set `target_class' to `a_class'
		do
			target_class := a_class
		end

	set_target_error_index (a_error_index: INTEGER)
			-- Set `minimization_class' to `a_error_index'
		do
			target_error_index := a_error_index
		end

	set_original_value (a_value: INTEGER)
			-- Set `original_value' to `a_value'
		do
			original_value := a_value
		end

	set_last_sat_value (a_value: INTEGER)
			-- Set `last_sat_value' to `a_value'
		do
			last_sat_value := a_value
		end
	set_minimization_tolerance (a_value: INTEGER)
			-- Set `minimization_tolerance' to `a_value'
		do
			minimization_tolerance := a_value
		end

	set_minimization_iteration_bound (a_value: INTEGER)
			-- Set `minimization_iteration_bound' to `a_value'
		do
			minimization_iteration_bound := a_value
		end

	set_number_of_iteration_for_fixing (a_value: INTEGER)
			-- Set `number_of_iteration_for_fixing' to `a_value'
		do
			number_of_iteration_for_fixing := a_value
		end

	number_of_iteration_for_fixing: INTEGER
			-- Number of iterations for generating fixes

	set_number_of_branches_of_current_loop (a_value: INTEGER)
			-- Set `number_of_branches_of_current_loop' to `a_value'
		do
			number_of_branches_of_current_loop := a_value
		end

	number_of_branches_of_current_loop: INTEGER
			-- Number of branches inside the current processed loop body

	set_is_unrolling_loop (a_value: BOOLEAN)
			-- set `is_unrolling_loop' to `a_value'
	do
			is_unrolling_loop := a_value
	end

	is_unrolling_loop: BOOLEAN
			-- Is the current translation process unrolling the loop?

feature -- Counterexample minimization

	original_value: INTEGER
			-- Value of the target variable in the original counterexample

	last_sat_value: INTEGER
			-- Value in the added constraint of the last satisfying verification run

	number_of_iterations: INTEGER
			-- Number of iterations during minimization

	increase_number_of_iterations
			-- Increase the number of iterations by 1
		do
			number_of_iterations := number_of_iterations + 1
		end

	test_generation_count: INTEGER
			-- Number of test generation runs

	increase_test_generation_count
			-- Increase the number of test generation run by 1
		do
			test_generation_count := test_generation_count + 1
		end

	num_bin_op_of_cond: INTEGER
			-- Number of boolean binary operators in the expression under processing

	increase_num_bin_op_of_cond
			-- Increase `num_bin_op_of_cond' by 1
		do
			num_bin_op_of_cond := num_bin_op_of_cond + 1
		end

	reset_num_bin_op_of_cond
			-- Set `num_bin_op_of_cond' to 0
		do
			num_bin_op_of_cond := 0
		end

	reset
			-- Reset parameters
		do
			number_of_iterations := 0
			opt_time := 0
			fix_elements.wipe_out
		end


feature --Postcondition mutation step

	is_postcondition_mutation_enabled: BOOLEAN
			-- Should postcondition mutation be executed?

	set_postcondition_mutation_enabled (a_value: BOOLEAN)
			-- Set `is_postcondition_mutation_enabled' to `a_value'.
		do
			is_postcondition_mutation_enabled := a_value
		end

	is_coupled_mutations_enabled: BOOLEAN
			-- Execute postcondition mutation with coupled mutations?
			-- This is usually the minimum, but can be turned off if uncoupled is used instead.

	set_coupled_mutations_enabled (a_value: BOOLEAN)
			-- Set `is_coupled_mutations_enabled' to `a_value'.
		do
			is_coupled_mutations_enabled := a_value
		end

	is_uncoupled_mutations_enabled: BOOLEAN
			-- Execute postcondition mutation with uncoupled mutations?

	set_uncoupled_mutations_enabled (a_value: BOOLEAN)
			-- Set `is_uncoupled_mutations_enabled' to `a_value'.
		do
			is_uncoupled_mutations_enabled := a_value
		end

	is_aging_enabled: BOOLEAN
			-- Execute postcondition mutation with variable aging?

	set_aging_enabled (a_value: BOOLEAN)
			-- Set `is_aging_enabled' to `a_value'.
		do
			is_aging_enabled := a_value
		end

feature -- Inlining options

	is_inlining_enabled: BOOLEAN
			-- Is inlining enabled?

	inlining_depth: INTEGER
			-- Current inlining depth.

	max_recursive_inlining_depth: INTEGER
			-- Maximum inlining depth for inlining recursive features.

	set_max_recursive_inlining_depth (a_value: INTEGER)
			-- Set `max_recursive_inlining_depth' to `a_value'.
		do
			max_recursive_inlining_depth := a_value
		end

	set_inlining_depth (a_value: INTEGER)
			-- Set `inlining_depth' to `a_value'.
		do
			inlining_depth := a_value
		end

	is_automatic_inlining_enabled: BOOLEAN
			-- Is automatic inlining of certain routines enabled?

	set_automatic_inlining_enabled (a_value: BOOLEAN)
			-- Set `is_automatic_inlining_enabled' to `a_value'.
		do
			is_automatic_inlining_enabled := a_value
		end

	routines_to_inline: LINKED_LIST [INTEGER]
			-- Routines to inline.
		once
			create Result.make
		end

feature -- Loop unrolling

	loop_unrolling_depth: INTEGER
			-- Loop unrolling depth.

	set_loop_unrolling_depth (a_value: INTEGER)
			-- Set `loop_unrolling_depth' to `a_value'.
		do
			loop_unrolling_depth := a_value
		end

	is_automatic_loop_unrolling_enabled: BOOLEAN
			-- Is automatic unrolling of certain loops enabled?

	set_automatic_loop_unrolling_enabled (a_value: BOOLEAN)
			-- Set `is_automatic_loop_unrolling_enabled' to `a_value'.
		do
			is_automatic_loop_unrolling_enabled := a_value
		end

	is_sound_loop_unrolling_enabled: BOOLEAN
			-- Is loop unrolling being done in a sound way?

	set_sound_loop_unrolling_enabled (a_value: BOOLEAN)
			-- Set `is_sound_loop_unrolling_enabled' to `a_value'.
		do
			is_sound_loop_unrolling_enabled := a_value
		end

feature -- Precondition and postcondition predicates

	is_postcondition_predicate_enabled: BOOLEAN
			-- Is generation of postcondition predicates enabled?

	set_postcondition_predicate_enabled (a_value: BOOLEAN)
			-- Set `is_postcondition_predicate_enabled' to `a_value'.
		do
			is_postcondition_predicate_enabled := a_value
		end

feature -- Arithmetic operations

	is_checking_overflow: BOOLEAN
			-- Is checking of overflow enabled?

	set_checking_overflow (a_value: BOOLEAN)
			-- Set `is_checking_overflow' to `a_value'.
		do
			is_checking_overflow := a_value
		end

feature -- Quantifiers

	is_generating_triggers: BOOLEAN
			-- Should AutoProof add triggers to quantified expressions?

	set_generating_triggers (a_value: BOOLEAN)
			-- Set `is_generating_triggers' to `a_value'.
		do
			is_generating_triggers := a_value
		end

	is_triggering_on_arithmetic: BOOLEAN
			-- Should arithmetic operations inside quantifiers be translated as functions,
			-- so that they can be used in triggers?

	set_triggering_on_arithmetic (a_value: BOOLEAN)
			-- Set `is_triggering_on_arithmetic' to `a_value'.
		do
			is_triggering_on_arithmetic := a_value
		end

	is_arithmetic_extracted: BOOLEAN
			-- Should arithmetic operations in function/map arguments inside quantifiers
			-- be extracted into fresh bound variables?

	set_arithmetic_extracted (a_value: BOOLEAN)
			-- Set `is_arithmetic_extracted' to `a_value'.
		do
			is_arithmetic_extracted := a_value
		end

	is_inv_check_independent: BOOLEAN
			-- Should each invariant clause be checked independently?

	set_inv_check_independent (a_value: BOOLEAN)
			-- Set `is_inv_check_independent' to `a_value'.
		do
			is_inv_check_independent := a_value
		end

	is_ignoring_nonvariant: BOOLEAN
			-- Should the "nonvariant" annotation be ignored?

	set_ignoring_nonvariant (a_value: BOOLEAN)
			-- Set `is_ignoring_nonvariant' to `a_value'.
		do
			is_ignoring_nonvariant := a_value
		end

feature -- Framing

	is_ownership_enabled: BOOLEAN
			-- Is ownership enabled?

	set_ownership_enabled (a_value: BOOLEAN)
			-- Set `is_ownership_enabled' to `a_value'.
		do
			is_ownership_enabled := a_value
		end

	is_ownership_defaults_enabled: BOOLEAN
			-- Is ownership enabled?

	set_ownership_defaults_enabled (a_value: BOOLEAN)
			-- Set `is_ownership_defaults_enabled' to `a_value'.
		do
			is_ownership_defaults_enabled := a_value
		end

feature -- Boogie/Z3

	is_enforcing_timeout: BOOLEAN
			-- Is timeout enforced?

	set_is_enforcing_timeout (a_value: BOOLEAN)
			-- Set `is_enforcing_timeout' to `a_value'.
		do
			is_enforcing_timeout := a_value
		end

	timeout: INTEGER
			-- Timeout of z3 in seconds.

	set_timeout (a_value: INTEGER)
			-- Set `timeout' to `a_value'.
		do
			timeout := a_value
		end


	is_trace_enabled: BOOLEAN
			-- Are trace statements printed?

	set_is_trace_enabled (a_value: BOOLEAN)
			-- Set `is_trace_enabled' to `a_value'.
		do
			is_trace_enabled := a_value
		end

feature -- Output

	is_print_time: BOOLEAN
			-- Is verification time output to the console?

	set_print_time (a_value: BOOLEAN)
			-- Set `is_time_output' to `a_value'.
		do
			is_print_time := a_value
		end

feature -- Counterexample optimization

	routines_to_optimize: LINKED_LIST [INTEGER]
			-- Routines to optimize.
		once
			create Result.make
		end

	features_to_optimize: LINKED_LIST [E2B_PROOF_TO_TEST_TARGET_FEATURE]
			-- Routines to optimize
		once
			create Result.make
		end

	container_to_optimize: HASH_TABLE [E2B_TYPE_A, STRING]
			-- Containers to be optimized
		once
			create Result.make (0)
		end

	model_files: LINKED_LIST [STRING]
			-- Model files

	init_states_of_counterexamples: LINKED_LIST [TUPLE [state: E2B_CE_STATE_OF_ROUTINE; target_class: E2B_CLASS_C; target_feature: E2B_FEATURE_I]]
			-- Initial states generated from counterexamples

	opt_preconditions: HASH_TABLE [HASH_TABLE [STRING, STRING], E2B_FEATURE_I]
			-- Mapping from a routine to preconditions for optimization
			-- Mapping: target feature -> list of `target variable -> precondition'
		once
			create Result.make (0)
		end

	last_opt_value: INTEGER
			-- Value used in the last optimization run

	set_last_opt_value (a_value: INTEGER)
			-- Set the value of last_opt_value to `a_value'
		do
			last_opt_value := a_value
		end

	opt_time: REAL
			-- Time used for optimization (time accumulation of all reverification)

	opt_lower: INTEGER
			-- Lower bound used in the binary search algorithm

	opt_upper: INTEGER
			-- Upper bound used in the binary search algorithm

	accumulate_opt_time (a_value: REAL)
			-- Increase the value of `opt_time' by `a_value'
		do
			opt_time := opt_time + a_value
		end

	set_opt_lower (a_value: INTEGER)
			-- Set the value of last_opt_value to `a_value'
		do
			opt_lower := a_value
		end

	set_opt_upper (a_value: INTEGER)
			-- Set the value of last_opt_value to `a_value'
		do
			opt_upper := a_value
		end

	is_minimize_sum: BOOLEAN
			-- Is the minimization of variables' sum ended?

	set_is_minimize_sum (a_value: BOOLEAN)
			-- Set the value of is_minimize_sum_end to `a_value'
		do
			is_minimize_sum := a_value
		end

feature -- Other

	is_generating_trivial_loop_variants: BOOLEAN
			-- Are trivially false loop variants generated?

	is_bulk_verification_enabled: BOOLEAN
			-- Are classes verified in bulk or by individual routines?

	set_bulk_verification_enabled (a_value: BOOLEAN)
			-- Set `is_bulk_verification_enabled' to `a_value'.
		do
			is_bulk_verification_enabled := a_value
		end

	max_parallel_boogies: INTEGER
			-- Maximum number of parallel Boogie instances.

	set_max_parallel_boogies (a_value: INTEGER)
			-- Set `max_parallel_boogies' to `a_value'.
		do
			max_parallel_boogies := a_value
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
