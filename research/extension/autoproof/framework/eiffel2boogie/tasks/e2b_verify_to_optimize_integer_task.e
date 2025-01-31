note
	description: "Task to re-verify with optimization."

class
	E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE; a_target_class: CLASS_C; a_target_feature: FEATURE_I; a_target_variables: HASH_TABLE [LINKED_LIST [STRING], FEATURE_I]; a_failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			target_class := a_target_class
			target_feature := a_target_feature
			target_variables := a_target_variables

			failed_verifications := a_failed_verifications

			remaining_tasks := a_tasks

			create l_translator_input.make
			create l_context
			has_next_step := True
			is_initial_verification := True

			l_boogie_universe := a_boogie_universe
				-- create l_boogie_universe.make
				-- boogie_universe_cell.put (l_boogie_universe)
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
			file_prefix: STRING
		do
			file_prefix := ""
			create result_generator.make
				-- l_context.options.routines_to_optimize.wipe_out

			if target_feature /= Void then -- run verification for the target procedure

				l_translator_input.feature_list.wipe_out
				l_translator_input.add_feature (target_feature)

				create optimization_verifier.make_with_prefix (target_class.name + "." + target_feature.feature_name_32.to_string_8) -- construct name of the boogie file

				helper.reset
				translation_pool.reset
				autoproof_errors.wipe_out


				remaining_tasks.start
				remaining_tasks.forth -- Skip current task in queue

				remaining_tasks.extend (create {E2B_TRANSLATE_OPTIMIZE_TASK}.make (l_translator_input, l_boogie_universe))
				remaining_tasks.extend (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, optimization_verifier))

				remaining_tasks.extend (create {E2B_EXECUTE_BOOGIE_TASK}.make (optimization_verifier))
				remaining_tasks.extend (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (optimization_verifier, result_generator, remaining_tasks))

					-- step into minimization
				remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_ITERATION_TASK}.make (boogie_universe, target_class, target_feature, target_variables, failed_verifications, result_generator, remaining_tasks))
			end

			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.

	optimization_verifier: detachable E2B_VERIFIER
			-- Boogie verifier.

	result_generator: attached E2B_RESULT_GENERATOR
			-- Result generator.

	l_translator_input: E2B_TRANSLATOR_INPUT
			-- Translator for Boogie code

	l_context: E2B_SHARED_CONTEXT
			-- Verification context

	target_variables: HASH_TABLE [LINKED_LIST [STRING], FEATURE_I]
			-- Variables to be optimized

	target_feature: detachable FEATURE_I
			-- Feature under optimization

	target_class: detachable CLASS_C
			-- Class of the target feature

	failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]
			-- Verification failures

	l_boogie_universe: IV_UNIVERSE
			-- Universe for boogie code generation

	model_file_name: STRING
			-- Name of the .model file

	is_initial_verification: BOOLEAN
			-- Is the verification task the first task in optimization?

	is_negative: BOOLEAN
			-- Is the initial value of the target variable negative?

	is_container_size: BOOLEAN
			-- Does the target variable represent the size of a container?

	initial_value: INTEGER
			-- Initial value of the target variable

	pre_cond: STRING
			-- Precondition to be added
		do
				-- Result := target_variable + " < " + initial_value.out
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
