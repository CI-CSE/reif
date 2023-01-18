note
	description: "Task to re-verify with inlining."

class
	E2B_VERIFY_FOR_NEW_COUNTEREXAMPLE_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_initial_result_generator: attached like initial_result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			print ("E2B_VERIFY_FOR_NEW_COUNTEREXAMPLE_TASK.make%N")
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
			print ("E2B_VERIFY_FOR_NEW_COUNTEREXAMPLE_TASK.step%N")
			if attached options.target_feature then
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
				remaining_tasks.forth -- Skip current taks in queue
				remaining_tasks.extend (create {E2B_TRANSLATE_OPTIMIZE_TASK}.make (l_translator_input, l_boogie_universe))
				remaining_tasks.extend (create {E2B_GENERATE_BOOGIE_TASK}.make (l_boogie_universe, new_verifier))

				remaining_tasks.put_left (create {E2B_EXECUTE_BOOGIE_WITH_RANDOM_SEED_TASK}.make (new_verifier))
				remaining_tasks.put_left (create {E2B_EVALUATE_BOOGIE_OUTPUT_TASK}.make (new_verifier, result_generator))
				has_next_step := False
			end
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
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
