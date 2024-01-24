note
	description: "Task to optimize the value of an integer variable."

class
	E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE; a_target_class: E2B_CLASS_C; a_target_feature: E2B_FEATURE_I; a_target_variables: HASH_TABLE [LINKED_LIST [STRING], E2B_FEATURE_I]; a_failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]; a_initial_result_generator: attached like initial_result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		local
			last_ce: TUPLE [E2B_CE_STATE_OF_ROUTINE, E2B_CLASS_C, E2B_FEATURE_I]
		do
			target_class := a_target_class
			target_feature := a_target_feature
			target_variables := a_target_variables
			target_variable := ""

			failed_verifications := a_failed_verifications
			initial_result_generator := a_initial_result_generator
			remaining_tasks := a_tasks
			l_boogie_universe := a_boogie_universe

			if target_variables.has (target_feature) then
				if not is_container_size (target_variables [target_feature].first) and options.is_minimize_sum then		-- minimize sum
					target_variable := sum_expression
				else								-- minimize ineger variable
					target_variable := target_variables [target_feature].first
				end
			end

			create translator_input.make
			has_next_step := True
			options.increase_number_of_iterations
			options.accumulate_opt_time (a_failed_verifications.item (a_failed_verifications.upper).time)

			last_ce := helper.options.init_states_of_counterexamples.last
			options.init_states_of_counterexamples.wipe_out
			options.init_states_of_counterexamples.extend (last_ce)
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	sleep_time: NATURAL = 0
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		local
			i: INTEGER
		do
			create result_generator.make
			l_boogie_universe.declarations.wipe_out
			set_status ("Minimize the value of " + target_variable + " in " + target_class.name + "." + target_feature.feature_name_32.to_string_8 + ", iteration " + options.number_of_iterations.out)

			get_initial_value; update_lower_upper

			if not is_converged or is_first_minimization_iteration then
					-- first iteration checks whether the value can be 0; otherwise, keep minimization until the minimal possible is reached
				translator_input.feature_list.wipe_out
				translator_input.add_feature (target_feature)

				create optimization_verifier.make_with_prefix (target_class.name + "." + target_feature.feature_name_32.to_string_8) -- name of boogie file

				add_opt_precond (pre_cond)

				options.set_last_opt_value (medium_value)

				helper.reset; translation_pool.reset; autoproof_errors.wipe_out
				add_minimization_task
			else
					-- minimization ends; collect the final precondition(s) in the last minimization run
				add_opt_precond (final_pre_cond); options.reset
				target_variables [target_feature].remove_i_th (1) -- finish minimization of the top integer variable; remove it from the list

				if options.is_minimize_sum and then not is_container_size (target_variable) then
					options.set_is_minimize_sum (False) -- reset configuration
					target_variables [target_feature].wipe_out -- finish minimization and remove all the integer variables for the target feature
				elseif is_container_size (target_variable) then
						-- if the variable is a container count, put all the items to the list of target variables for minimization
					from
						i := 1
					until
						i > final_value -- minimized container size
					loop
						target_variables [target_feature].extend (target_variable.split ('.').first + ".item." + i.out)
						i := i + 1
					end
				end

				reset
				minimize_next_variable
			end

			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	minimize_next_variable
			-- Remove the current variables from `target_variables'; add minimization task for the immediate next top `target variable'
		do
			if not target_variables [target_feature].is_empty then
				remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_feature, target_variables, failed_verifications, remaining_tasks))
			else
				target_variables.remove (target_feature)
				if not target_variables.is_empty then
					options.opt_preconditions.wipe_out
					remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_variables.current_keys [1], target_variables, failed_verifications, remaining_tasks))
				end
			end
		end

	reset
			-- Reset relevant data in options
		do
			options.set_opt_lower (0); options.set_opt_upper (0); options.set_last_opt_value (0)
		end

	is_first_minimization_iteration: BOOLEAN
			-- Is the current minimization the 1st iteration for the current target variable?
		do
			Result := options.number_of_iterations = 1
		end

	update_lower_upper
			-- Update `lower' and `upper' values in the binary search algorithm, based on the verification result
		do
				-- perform a verification on the target feature at the 1st iteration to check whether the minimal is 0

			if not is_same_result and options.number_of_iterations = 2 then
				options.set_opt_upper (options.original_value)
			elseif is_same_result or options.number_of_iterations = 2 then -- start minimization following the binary search strategy from the 2nd iteration
				options.set_opt_upper (initial_value)
			elseif options.last_opt_value < 0 and options.number_of_iterations > 1 then
				options.set_opt_lower (options.last_opt_value - 1)
			elseif options.last_opt_value > 0 and options.number_of_iterations > 1 then
				options.set_opt_lower (options.last_opt_value + 1)
			end

		end

	get_initial_value
			-- Retrieve initial value from counterexample
		do
			if options.is_minimize_sum then
				initial_value := get_sum_from_counterexample (target_feature)
			else
				initial_value := get_value_from_counterexample (target_variable)
			end

			if options.number_of_iterations = 1 then
				options.set_original_value (initial_value)
			end
		end

	add_minimization_task
			-- Add optimization task
		do
			remaining_tasks.start
			remaining_tasks.forth -- Skip current task in queue

			remaining_tasks.extend (create {E2B_TRANSLATE_OPTIMIZE_TASK}.make (translator_input, l_boogie_universe))
			remaining_tasks.extend (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, optimization_verifier))

			remaining_tasks.extend (create {E2B_EXECUTE_BOOGIE_TASK}.make (optimization_verifier))
			remaining_tasks.extend (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (optimization_verifier, result_generator, remaining_tasks))

			remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK}.make (boogie_universe, target_class, target_feature, target_variables, failed_verifications, result_generator, remaining_tasks))
		end

	add_opt_precond (a_precond: STRING)
		local
			l_pre: HASH_TABLE [STRING, STRING]
		do
			if options.opt_preconditions.has (target_feature) then -- add precondition

				if options.opt_preconditions [target_feature].has (target_variable) then
					options.opt_preconditions [target_feature] [target_variable].copy (a_precond)
				else
					options.opt_preconditions [target_feature] [target_variable] := ""
					options.opt_preconditions [target_feature] [target_variable].copy (a_precond)
				end
			else
				create l_pre.make (0)
				l_pre.extend (a_precond, target_variable)
				options.opt_preconditions.extend (l_pre, target_feature)
			end
		end

	get_value_from_counterexample (a_var: STRING): INTEGER
			-- Get value of `a_var' in the counterexample
		local
			model_file: PLAIN_TEXT_FILE
			ce: E2B_BOOGIE_COUNTEREXAMPLE
			l_value, max: INTEGER
			models: ARRAY [IMMUTABLE_STRING_32]
			model_file_content: STRING
			initial_state: E2B_CE_STATE_OF_ROUTINE
			value: STRING
		do
			model_file_content := ""; value := ""
				-- read the model of the target procedure
			create model_file.make_open_read (model_file_name)
			model_file.read_stream (1000000)
			model_file_content.copy (model_file.last_string)

			models := split_models (model_file_content)

			across models as m loop
				create ce.make (m)
				initial_state := (create {E2B_CE_TRACE_OF_ROUTINE}.make (ce)).initial_state

				if is_container_size (a_var) and then attached {E2B_CE_VALUE_SEQ} initial_state.values [a_var.split ('.').first] as seq then
					if seq.length >= 0 then
						value := seq.length.out
					end
				elseif is_container_item (a_var) and then attached {E2B_CE_VALUE_SEQ} initial_state.values [a_var.split ('.').first] as seq then
					if seq.items.has (a_var.split ('.').last) then
						check seq.items [a_var.split ('.').last].is_string_8 then end
						value := seq.items [a_var.split ('.').last].to_string_8
					end
				else
					check initial_state.locals [a_var].is_string_8 then end
					value.copy (initial_state.locals [a_var].to_string_8)
				end

				if value.has ('-') then -- negative value
					l_value := value.split ('(').last.split (')').first.to_integer.abs
				else
					l_value := value.to_integer
				end
				max := if l_value > max then l_value else max end
			end

			if is_same_result then
				options.set_last_sat_value (max)
			end

			Result := max
				--TODO:  if the counterexample model does not exist, then assign a randomly large value, a default value would be 100
		end

	get_sum_from_counterexample (a_feature: E2B_FEATURE_I): INTEGER
			-- Get the sum of all integer variables of `a_feature' in the counterexample
		local
			l_sum: INTEGER
		do
			across target_variables [a_feature] as v loop -- sum up absolute values of all integer variables
				l_sum := l_sum + get_value_from_counterexample (v).to_integer.abs
			end
			Result := if l_sum < 0 then {INTEGER}.max_value else l_sum end
		end

	split_models (model_file_content: STRING_32): ARRAY [IMMUTABLE_STRING_32]
			-- Split the content of the input .model file into a list of models
		require
			model_not_empty: not model_file_content.is_empty
		local
			i, end_of_model: INTEGER
			model: STRING_32
			models: ARRAY [IMMUTABLE_STRING_32]
		do
			create models.make_empty
			from
				i := 1; model := ""
			until
				i = model_file_content.count
			loop
				end_of_model := model_file_content.substring_index ("END_MODEL", i)
				if end_of_model /= 0 then
					model.copy (model_file_content.substring (i, end_of_model))
					models.force (model, models.count + 1)
					i := end_of_model + 1
				else
					i := model_file_content.count
				end
			end

			Result := models
		end

	safe_file_name (a_file_name: STRING): STRING
			-- Safe version of `a_file_name' in case of space.
		do
			Result := if a_file_name.has (' ') then "%"" + a_file_name + "%"" else a_file_name end
		end

feature {NONE} -- Implementation

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.

	initial_result_generator: attached E2B_RESULT_GENERATOR
			-- Result generator of the initial verification

	optimization_verifier: detachable E2B_VERIFIER
			-- Boogie verifier.

	result_generator: attached E2B_RESULT_GENERATOR
			-- Result generator.

	translator_input: E2B_TRANSLATOR_INPUT
			-- Translator for Boogie code

	target_variable: STRING
			-- Variable under optimization

	target_variables: HASH_TABLE [LINKED_LIST [STRING], E2B_FEATURE_I]
			-- List of variables to be optimized

	target_feature: detachable E2B_FEATURE_I
			-- Feature under optimization

	target_class: detachable E2B_CLASS_C
			-- Class of the target feature

	failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]
			-- Verification failures

	l_boogie_universe: IV_UNIVERSE
			-- Universe for boogie code generation

	model_file_name: STRING
			-- Name of the .model file; given in the format `target_class.target_feature.model'
		do
			Result := system.eiffel_project.project_directory.target_path.extended ("Proofs").extended (target_class.name + "." + target_feature.feature_name_32.to_string_8 + ".model").out
		end

	is_negative: BOOLEAN
			-- Is the initial value of the target variable negative?

	is_container_size (a_var: STRING): BOOLEAN
			-- Does the target variable represent the size of a container?
		do
			Result := a_var.has_substring (".count") and then options.container_to_optimize.has (a_var.split ('.').first)
		end

	is_container_item (a_var: STRING): BOOLEAN
			-- Does the target variable represent an element of a container?
		do
			Result := a_var.has_substring (".item") and then options.container_to_optimize.has (a_var.split ('.').first)
		end

	initial_value: INTEGER
			-- Initial value of the target variable

	get_variable_name (a_var: STRING): STRING
			-- Variable name in the boogie code
		local
			object_name, object_type, field_name: STRING
		do

			if a_var.has ('.') then
				object_name := a_var.split ('.').first
				if is_container_size (a_var) then
						-- free requires (fun.SIMPLE_ARRAY^INTEGER_32^.count(Heap, a)) >= (0) && (fun.SIMPLE_ARRAY^INTEGER_32^.count(Heap, a)) <= 12955;
					object_type := options.container_to_optimize [object_name].name
					Result := "(fun." + safe_type (object_type) + ".count(Heap, " + object_name + "))"
				elseif is_container_item (a_var) then
						-- (Seq#Item(Heap[a, SIMPLE_ARRAY^INTEGER_32^.sequence], i_2)
					object_type := options.container_to_optimize [object_name].name
					Result := "(Seq#Item(Heap[" + object_name + ", " + safe_type (object_type) + ".sequence], " + a_var.split ('.').last + "))"

				else
					field_name := target_class.actual_type.name + "." + a_var.split ('.').last
					Result := "Heap[" + object_name + ", " + field_name + "]"
				end

			else
				Result := a_var
			end

		end

	gradient_descent_value: INTEGER
			-- Minimization following gradient descent distribution
		do

		end

	medium_value: INTEGER
			-- Medium value in the binary search algorithm
		do
			Result := options.opt_lower + (options.opt_upper - options.opt_lower) // 2 -- integer division
		end

	pre_cond: STRING
			-- Precondition to be added
		do
			Result := if options.is_minimize_sum then minimize_sum_pre_cond else minimize_var_pre_cond end
		end

	sum_expression: STRING
			-- Sum up all the integer variables of target feature
		local
			i: INTEGER
		do
			Result := ""
			from
				i := 1
			until
				i = target_variables [target_feature].count
			loop
				Result := Result + "abs(" + get_variable_name (target_variables [target_feature] [i]) + ") + "
				i := i + 1
			end

			Result := Result + "abs(" + get_variable_name (target_variables [target_feature].last) + ") "
		end

	minimize_sum_pre_cond: STRING
			-- Precondition for minimizing the sum of absolute values of all integer variables of target routine
		do
			Result := ""
			if options.number_of_iterations > 1 then
				Result := sum_expression + " <= " + medium_value.out
			else
				Result := sum_expression + " <= " + {INTEGER}.max_value.out -- find "sum <= max" at the first iteration
			end
		end

	minimize_var_pre_cond: STRING
			-- Precondition for minimizing an integer variable
		do
			Result := "abs(" + get_variable_name (target_variable) + ") <= " + medium_value.abs.out
		end

	final_value: INTEGER
		do
			Result := if options.number_of_iterations > 1 and initial_value.abs = 1 then initial_value else medium_value end
		end

	final_pre_cond: STRING
			-- Precondition to be added
		local
			l_value: INTEGER
		do
			if not is_same_result then
				l_value := options.last_sat_value
			elseif options.number_of_iterations > 1 and initial_value.abs = 1 then
				l_value := initial_value
			else
				l_value := medium_value
			end

			Result := if l_value >= 0 then "abs(" + get_variable_name (target_variable) + ") <= " + l_value.out else "abs(" + get_variable_name (target_variable) + ") <= " + "(" + l_value.out + ")" end
		end

	is_same_result: BOOLEAN
			-- Is the verification result remain the same?
		local
			i, j, error_count, equal_count: INTEGER
			target_failed_verifications: LINKED_LIST [E2B_FAILED_VERIFICATION]
		do
			Result := False
			create target_failed_verifications.make

			from
				i := 1
			until
				i > failed_verifications.upper - failed_verifications.lower + 1
			loop
				if equal (failed_verifications [i].context_feature, target_feature) then
					target_failed_verifications.extend (failed_verifications [i])
				end
				i := i + 1
			end

			if target_failed_verifications.count = (initial_result_generator.last_result.failed_verifications.upper - initial_result_generator.last_result.failed_verifications.lower + 1) then
				from
					i := 1
				until
					i > target_failed_verifications.count
				loop -- compare the failure one by one
					if target_failed_verifications [i].errors.count = initial_result_generator.last_result.failed_verifications [i].errors.count then
							-- TODO: use the context line number to distinguish different verification failures
						from
							j := 1
						until
							j > target_failed_verifications [i].errors.count
						loop
							if target_failed_verifications [i].errors [j].context_line_number = target_failed_verifications [i].errors [j].context_line_number then
								error_count := error_count + 1
							end
							j := j + 1
						end

						if error_count = target_failed_verifications [i].errors.count then
							equal_count := equal_count + 1
						end

						error_count := 0
							-- target_failed_verifications[i].single_line_message (a_formatter: TEXT_FORMATTER)
					end

					i := i + 1
				end

				if equal_count = target_failed_verifications.count then -- verification result remains the same, continue minimization
					Result := True
					options.set_is_same_result (True)
				end
			end
		end

	is_converged: BOOLEAN
			-- Stop criterion
		do
			if initial_value = 0 and options.number_of_iterations < 2 then
				Result := True
			elseif initial_value = 0 and options.number_of_iterations >= 2 and is_same_result then
				Result := True
			elseif (options.number_of_iterations > 2 and options.opt_lower.abs + (options.minimization_tolerance) >= options.opt_upper.abs) then
				Result := True
			elseif (options.number_of_iterations >= options.minimization_iteration_bound) then
				Result := True
			elseif (options.number_of_iterations > 1 and initial_value.abs = 1) then
				Result := True
			end
				-- TODO: use tolerance and max iteration for limiting the times of iteration
		end

	safe_type (type: STRING): STRING
			-- Convert the name of container type
		local
			t, item_type: STRING
			tuple_field_types: LIST [STRING]
			i: INTEGER
		do
			t := ""; Result := ""; item_type := ""

			if type.has_substring ("[") then
				if type.has_substring ("V_ARRAY") then
					item_type.copy (type.split ('[') [2].split (']').first)
					t := t + "V_ARRAY" + "^" + item_type + "^"
				elseif type.has_substring ("SIMPLE_ARRAY") then
					item_type.copy (type.split ('[') [2].split (']').first)
					t := t + "SIMPLE_ARRAY" + "^" + item_type + "^"
				elseif type.has_substring ("LIST") then
					item_type.copy (type.split ('[') [2].split (']').first)
					t := t + "LIST" + "^" + item_type + "^"
				elseif type.has_substring ("TUPLE") then
					tuple_field_types := type.split ('#')
					tuple_field_types [1].copy (tuple_field_types [1].split ('^').last)
					t := t + "TUPLE" + "^"

					from
						i := 1
					until
						i = tuple_field_types.count
					loop
						t := t + tuple_field_types [i] + ","
						i := i + 1
					end

					t := t + tuple_field_types [i].split (']').first + "^"
				end
			else
				t := type
			end
			Result.copy (t)
		end

	safe_name (name: STRING): STRING
			-- Get a valid name
		do
			if name.has_substring ("@@") then
				Result := name.split ('@').first
			elseif name.has ('.') then
				Result := safe_type (name.split ('.').first) + "." + name.split ('.').last
			else
				Result := name
			end
		end

note
	date: "$Date: 2022-01-18 20:46:44 +0100 (Tue, 18 Jan 2022) $"
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
