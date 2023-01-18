note
	description: "Task to re-verify with optimization."

class
	E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE; a_target_class: CLASS_C; a_target_feature: FEATURE_I; a_target_variables: HASH_TABLE [LINKED_LIST [STRING_32], FEATURE_I]; a_failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]; a_initial_result_generator: attached like initial_result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
				-- print ("run E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK.make for " + "%N")
			target_class := a_target_class
			target_feature := a_target_feature

			target_variables := a_target_variables

			if a_target_variables [target_feature].count > 0 then
				target_variable := a_target_variables [target_feature].first
			else
				target_variable := ""
			end
				-- print ("integer : " + target_variable.to_string_8 + "%N")

			failed_verifications := a_failed_verifications

			initial_result_generator := a_initial_result_generator

			remaining_tasks := a_tasks

			create l_translator_input.make
			create l_context
			has_next_step := True
			l_boogie_universe := a_boogie_universe

			options.increase_number_of_iterations
			options.accumulate_opt_time (a_failed_verifications.item (a_failed_verifications.upper).time)
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
			pre: HASH_TABLE [IMMUTABLE_STRING_32, IMMUTABLE_STRING_32]
			i: INTEGER
		do
				-- print ("run E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK.step for integer " + target_variable.to_string_8 + "%N")
			set_status ("Minimize the value of " + target_variable.to_string_8 + " in " + target_class.name.to_string_8 + "." + target_feature.feature_name_32.to_string_8 + ", iteration " + options.number_of_iterations.out)

			create result_generator.make
			l_boogie_universe.declarations.wipe_out

			if target_variable.has_substring (".count") and then l_context.options.container_to_optimize.has (target_variable.split ('.').first) then -- target variable represents container size
				is_container_size := True
			elseif target_variable.has_substring (".item") and then l_context.options.container_to_optimize.has (target_variable.split ('.').first) then
				is_container_item := True
			end

			-- if is_same_result then
				initial_value := get_value_from_counterexample
			-- end

			if l_context.options.number_of_iterations > 1 then
				if is_same_result or l_context.options.number_of_iterations = 2 then
					l_context.options.set_opt_upper (initial_value)
				else
					if l_context.options.last_opt_value < 0 then
						l_context.options.set_opt_lower (l_context.options.last_opt_value - 1)
					else
						l_context.options.set_opt_lower (l_context.options.last_opt_value + 1)
					end
				end
			end

				-- Heap[Current, ACCOUNT.balance]
				-- print ("lower:  " + l_context.options.opt_lower.out + "%N")
				-- print ("upper:  " + l_context.options.opt_upper.out + "%N")
				-- print ("number of iterations:  " + l_context.options.number_of_iterations.out + "%N")

			if l_context.options.number_of_iterations = 1 or not is_converged then -- not converged
				l_translator_input.feature_list.wipe_out
				l_translator_input.add_feature (target_feature)

				create optimization_verifier.make_with_prefix (target_class.name.to_string_8 + "." + target_feature.feature_name_32.to_string_8) -- name of boogie file

				if l_context.options.opt_preconditions.has (target_feature) then -- add precondition
					if l_context.options.opt_preconditions [target_feature].has (target_variable) then -- overwrite previous added precondition
						l_context.options.opt_preconditions [target_feature] [target_variable].copy (pre_cond)
					else
						l_context.options.opt_preconditions [target_feature] [target_variable] := ""
						l_context.options.opt_preconditions [target_feature] [target_variable].copy (pre_cond)
					end
				else
					create pre.make (0)
					pre.extend (pre_cond, target_variable)
					l_context.options.opt_preconditions.extend (pre, target_feature)
				end

				l_context.options.set_last_opt_value (medium_value)

				helper.reset
				translation_pool.reset
				autoproof_errors.wipe_out

				remaining_tasks.start
				remaining_tasks.forth -- Skip current task in queue

				remaining_tasks.extend (create {E2B_TRANSLATE_OPTIMIZE_TASK}.make (l_translator_input, l_boogie_universe))
				remaining_tasks.extend (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, optimization_verifier))

				remaining_tasks.extend (create {E2B_EXECUTE_BOOGIE_TASK}.make (optimization_verifier))
				remaining_tasks.extend (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (optimization_verifier, result_generator))

				remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK}.make (boogie_universe, target_class, target_feature, target_variables, failed_verifications, result_generator, remaining_tasks))

			else
					-- form the final precondition

				if l_context.options.opt_preconditions.has (target_feature) then -- add precondition
					if l_context.options.opt_preconditions [target_feature].has (target_variable) then -- overwrite
						l_context.options.opt_preconditions [target_feature] [target_variable].copy (final_pre_cond)
					else
						l_context.options.opt_preconditions [target_feature] [target_variable] := ""
						l_context.options.opt_preconditions [target_feature] [target_variable].copy (final_pre_cond)
					end
				else
					create pre.make (0)
					pre.extend (final_pre_cond, target_variable)
					l_context.options.opt_preconditions.extend (pre, target_feature)
				end

				l_context.options.reset

					-- l_context.options.opt_preconditions [target_feature] [target_variable].copy (final_pre_cond)
					-- print ("replace with the last precondition")
				target_variables [target_feature].remove_i_th (1) -- remove the first element
					-- check if the variable represents a container size, if yes, put all the item name to the target variable list

				if is_container_size then
					from
						i := 1
					until
						i > final_value -- l_context.options.last_opt_value
					loop
						target_variables [target_feature].extend (target_variable.split ('.').first + ".item." + i.out) -- sequence items to be optimized
						i := i + 1
					end
				end

					-- reset lower and upper
				l_context.options.set_opt_lower (0)
				l_context.options.set_opt_upper (0)
				l_context.options.set_last_opt_value (0)

				if not target_variables [target_feature].is_empty then
					remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_feature, target_variables, failed_verifications, remaining_tasks))
				else
					target_variables.remove (target_feature)
					if not target_variables.is_empty then
						l_context.options.opt_preconditions.wipe_out
						remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_variables.current_keys [1], target_variables, failed_verifications, remaining_tasks))
					end
				end
			end

			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE}

	get_value_from_counterexample: INTEGER
			-- Get value of `a_var' in the counterexample
		local
			model_file: PLAIN_TEXT_FILE
			ce: E2B_BOOGIE_COUNTEREXAMPLE
			max: INTEGER
			models: ARRAY [IMMUTABLE_STRING_32]
			model_file_content: STRING_32
			initial_state: E2B_INITIAL_STATE_OF_ROUTINE
			value: STRING_32
		do
			model_file_content := ""; value := ""
				-- read the model of the target procedure
			model_file_name := system.eiffel_project.project_directory.target_path.extended ("Proofs").extended (target_class.name.to_string_8 + "." + target_feature.feature_name_32.to_string_8 + ".model").out
			create model_file.make_open_read (model_file_name)
			model_file.read_stream (1000000)
			model_file_content.copy (model_file.last_string)

			models := split_models (model_file_content)

			across models as m loop
				create ce.make (m)
				create initial_state.make (target_feature, target_class, ce)

				if is_container_size then
					value.copy (initial_state.container_size_named (target_variable.split ('.').first))
				elseif is_container_item then
					value.copy (initial_state.container_item_named (target_variable.split ('.').first, target_variable.split ('.').last))
				else
					value.copy (initial_state.value_named (target_variable))
				end

				if value.to_integer > max then -- if there are multiple counterexample models, read all the values and get the maximum
					max := value.to_integer
				elseif value.has ('-') then -- negative value
					max := value.split ('(').last.split (')').first.to_integer
				end
			end

			Result := max
            -- last_value := Result
            -- last models
			print ("initial value from model: " + max.out + "%N")
				--TODO:  if the counterexample model does not exist, then assign a randomly large value, a default value would be 100
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
				i := 1
				model := ""
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

	safe_file_name (a_file_name: STRING_32): STRING_32
			-- Safe version of `a_file_name' in case of space.
		do
			if a_file_name.has (' ') then
				Result := "%"" + a_file_name.to_string_8 + "%""
			else
				Result := a_file_name
			end
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

	l_translator_input: E2B_TRANSLATOR_INPUT
			-- Translator for Boogie code

	l_context: E2B_SHARED_CONTEXT
			-- Verification context

	target_variable: STRING_32
			-- Variable under optimization

	target_variables: HASH_TABLE [LINKED_LIST [STRING_32], FEATURE_I]
			-- List of variables to be optimized

	target_feature: detachable FEATURE_I
			-- Feature under optimization

	target_class: detachable CLASS_C
			-- Class of the target feature

	failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]
			-- Verification failures

	l_boogie_universe: IV_UNIVERSE
			-- Universe for boogie code generation

	model_file_name: STRING_32
			-- Name of the .model file

	is_negative: BOOLEAN
			-- Is the initial value of the target variable negative?

	is_container_size: BOOLEAN
			-- Does the target variable represent the size of a container?

	is_container_item: BOOLEAN
			-- Does the target variable represent an element of a container?

	initial_value: INTEGER
			-- Initial value of the target variable

	get_variable_name: STRING_32
			-- Variable name in the boogie code
		local
			object_name, object_type, field_name: STRING_32
		do
			if target_variable.has ('.') then
				object_name := target_variable.split ('.').first
				if is_container_size then
						-- free requires (fun.SIMPLE_ARRAY^INTEGER_32^.count(Heap, a)) >= (0) && (fun.SIMPLE_ARRAY^INTEGER_32^.count(Heap, a)) <= 12955;
					object_type := l_context.options.container_to_optimize [object_name].name
					Result := "(fun." + safe_type (object_type).to_string_8 + ".count(Heap, " + object_name.to_string_8 + "))"
				elseif is_container_item then
						-- (Seq#Item(Heap[a, SIMPLE_ARRAY^INTEGER_32^.sequence], i_2)
					object_type := l_context.options.container_to_optimize [object_name].name
					Result := "(Seq#Item(Heap[" + object_name.to_string_8 + ", " + safe_type (object_type).to_string_8 + ".sequence], " + target_variable.split ('.').last.to_string_8 + "))"

				else
					field_name := target_class.actual_type.name.to_string_8 + "." + target_variable.split ('.').last.to_string_8
					Result := "Heap[" + object_name.to_string_8 + ", " + field_name.to_string_8 + "]"
				end

			else
				Result := target_variable
			end
		end

	gradient_descent_value: INTEGER
		do

		end

	medium_value: INTEGER
			-- Medium value in the binary search algorithm
		do
			Result := l_context.options.opt_lower + (l_context.options.opt_upper - l_context.options.opt_lower) // 2 -- integer division
		end

	pre_cond: STRING_32
			-- Precondition to be added
			--local
			--	medium: INTEGER
		do
				-- Heap[Current, ACCOUNT.balance]
				-- print ("lower:  " + l_context.options.opt_lower.out + "%N")
				-- print ("upper:  " + l_context.options.opt_upper.out + "%N")
				-- medium := l_context.options.opt_lower + (l_context.options.opt_upper - l_context.options.opt_lower) // 2 -- integer division

			if medium_value >= 0 then
				Result := get_variable_name.to_string_8 + " >= 0 " + " && " + get_variable_name.to_string_8 + " <= " + medium_value.out
			elseif medium_value < 0 then
				Result := get_variable_name.to_string_8 + " <= 0 " + " && " + get_variable_name.to_string_8 + " >= " + "(" + medium_value.out + ")"
			end
		end

	final_value: INTEGER
		do
			if l_context.options.number_of_iterations > 1 and abs (initial_value) = 1 then
				Result := initial_value
			else
				Result := medium_value
			end
		end

	final_pre_cond: STRING_32
			-- Precondition to be added
		local
			value: INTEGER
		do
				--	medium := l_context.options.opt_lower + (l_context.options.opt_upper - l_context.options.opt_lower) // 2 -- integer division
				-- print ("l_context.options.number_of_iterations" + l_context.options.number_of_iterations.out + " initial_value:  " + initial_value.out + "%N")
			if l_context.options.number_of_iterations > 1 and abs (initial_value) = 1 then
				value := initial_value
			else
				value := medium_value
			end

			if value >= 0 then
				Result := get_variable_name.to_string_8 + " == " + value.out
			else
				Result := get_variable_name.to_string_8 + " == " + "(" + value.out + ")"
			end
		end

	is_same_result: BOOLEAN
			-- Is the verification result remain the same?
		local
			i, j, error_count, equal_count: INTEGER
			target_failed_verifications: LINKED_LIST [E2B_FAILED_VERIFICATION]
		do
				-- analyze the verification results to decide whether to have next verification
				-- compare the verification failure of the target procedure from the information of result_generator?
				-- initial_result_generator and result_generator
				-- store the initial verification result in ?

			Result := False
			create target_failed_verifications.make

			from
				i := 1
			until
				i > failed_verifications.upper - failed_verifications.lower + 1
			loop
					-- print ("failed verification for: " + failed_verifications [i].context_feature.feature_name_32.to_string_8 + "%N")
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
						-- print ("target failed verification for: " + target_failed_verifications [i].context_feature.feature_name_32.to_string_8 + "%N")
						-- print ("initial result failed verification for: " + initial_result_generator.last_result.failed_verifications [i].context_feature.feature_name_32.to_string_8 + "%N")
					if target_failed_verifications [i].errors.count = initial_result_generator.last_result.failed_verifications [i].errors.count then
							-- TODO: use the context line number to distinguish different verification failures
						from
							j := 1
						until
							j > target_failed_verifications [i].errors.count
						loop
								-- print ("context line number" + target_failed_verifications [i].errors [1].context_line_number.out + "%N")
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
					l_context.options.set_is_same_result (True)
					print ("same verification result : " + equal_count.out + "%N")
				end
			end
		end

	is_converged: BOOLEAN
			-- Stop criteria
		do
			Result := initial_value = 0
				or (l_context.options.number_of_iterations > 2 and abs (l_context.options.opt_lower) + (l_context.options.minimization_tolerance) >= abs (l_context.options.opt_upper))
				or (l_context.options.number_of_iterations >= l_context.options.minimization_iteration_bound)
				or (l_context.options.number_of_iterations > 1 and abs (initial_value) = 1)
				-- TODO: use tolerance and max iteration for limiting the times of iteration
		end

	abs (value: INTEGER): INTEGER
			-- Absolute value of an integer
		do
			if value >= 0 then
				Result := value
			else
				Result := - value
			end
		end

	safe_type (type: STRING_32): STRING_32
			-- Convert the name of container type
		local
			t, item_type: STRING_32
			tuple_field_types: LIST [STRING_32]
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

	safe_name (name: STRING_32): STRING_32
			-- Get a valid name
		do
			if name.has_substring ("@@") then
				Result := name.split ('@').first
					-- elseif name.same_string ("Current") then
					--	Result := "current_object"
			elseif name.has ('.') then
				Result := safe_type (name.split ('.').first).to_string_8 + "." + name.split ('.').last.to_string_8
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
