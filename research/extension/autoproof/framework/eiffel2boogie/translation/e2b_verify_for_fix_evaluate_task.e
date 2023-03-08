note
	description: "Task to re-verify with inlining."

class
	E2B_VERIFY_FOR_FIX_EVALUATE_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization
	-- remaining_tasks.extend (create {E2B_VERIFY_FOR_FIX_EVALUATE_TASK}.make (options.last_result, options.target_feature, result_generator, remaining_tasks))
	make (a_target_feature: FEATURE_I; a_failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]; a_initial_result_generator: attached like initial_result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			-- print ("E2B_VERIFY_FOR_FIX_EVALUATE_TASK.make%N")
			target_feature := a_target_feature

			failed_verifications := a_failed_verifications

			initial_result_generator := a_initial_result_generator
			remaining_tasks := a_tasks
			has_next_step := True
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	sleep_time: NATURAL = 0
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>120
		local
			l_translator_input: E2B_TRANSLATOR_INPUT
			l_boogie_universe: IV_UNIVERSE
			-- l_context: E2B_SHARED_CONTEXT
		do
			-- print ("E2B_VERIFY_FOR_FIX_EVALUATE_TASK.step%N")
			if is_error_eliminated then
			    options.set_fix_message ("Fix: adding precondition " + options.last_candidate_fix.to_string_8 + " for " + options.target_feature.feature_name_32.to_string_8)

		   elseif attached options.target_feature then
				create l_translator_input.make
				l_translator_input.add_feature (options.target_feature)

				create l_boogie_universe.make
				boogie_universe_cell.put (l_boogie_universe)
				helper.reset
				result_handlers.wipe_out

				create new_verifier.make_with_prefix (options.target_class.name.to_string_8 + "." + options.target_feature.feature_name_32.to_string_8) -- construct name of the boogie file
					-- TODO
				create result_generator.make
				remaining_tasks.start
				remaining_tasks.forth -- Skip current task in queue
				remaining_tasks.extend (create {E2B_TRANSLATE_OPTIMIZE_TASK}.make (l_translator_input, l_boogie_universe))
				remaining_tasks.extend (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, new_verifier))

				remaining_tasks.put_left (create {E2B_EXECUTE_BOOGIE_TASK}.make (new_verifier))
				remaining_tasks.put_left (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (new_verifier, result_generator))

				if not options.fix_preconditions.is_empty then
			        remaining_tasks.extend (create {E2B_VERIFY_FOR_FIX_EVALUATE_TASK}.make (options.target_feature, options.last_result.failed_verifications, result_generator, remaining_tasks))
				end
			end
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

	is_error_eliminated: BOOLEAN
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
				if failed_verifications [i].context_feature.body_index = target_feature.body_index then
					target_failed_verifications.extend (failed_verifications [i])
					-- print("failed feature: " + failed_verifications [i].context_feature.body_index.out + "%N")
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

				-- if equal_count < target_failed_verifications.count then -- verification result remains the same, continue minimization
				--	Result := True
					-- l_context.options.set_is_same_result (True)
				--	print ("same verification result : " + equal_count.out + "%N")
				--end
				-- print("failures: " + target_failed_verifications.count.out + "%N")
			end

			if target_failed_verifications.count = 0  then
				Result := True
			end
		end


feature {NONE} -- Implementation

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.

	initial_result_generator: attached E2B_RESULT_GENERATOR
			-- Boogie verifier.

	new_verifier: detachable E2B_VERIFIER
			-- Boogie verifier.

	result_generator: attached E2B_RESULT_GENERATOR
			-- Result generator.

	target_feature: detachable FEATURE_I
			-- Feature under optimization

	failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]
			-- Verification failures

	boogie_executable: E2B_PLATFORM_EXECUTABLE_IMPL

	;

note
	date: "$Date: 2022-01-19 03:46:44 +0800 (Wed, 19 Jan 2022) $"
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
