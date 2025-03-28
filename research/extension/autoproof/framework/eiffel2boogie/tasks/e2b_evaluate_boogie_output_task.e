note
	description: "Task to evaluate Boogie output."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_EVALUATE_BOOGIE_OUTPUT_TASK

inherit

	ROTA_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_verifier: attached like verifier; a_result_generator: like result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			verifier := a_verifier
			result_generator := a_result_generator
			has_next_step := True
			remaining_tasks := a_tasks
				-- verifier.helper.options.init_states_of_counterexamples.wipe_out
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	is_interface_usable: BOOLEAN = True
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		do
			if attached verifier.last_output then
				verifier.parse_verification_output
				result_generator.process_boogie_result (verifier.last_result)
			end
			verifier.helper.options.set_last_result (result_generator.last_result)

				-- Minimize counterexamples
--			if not verifier.helper.options.last_result.is_verification_successful and then not verifier.helper.options.is_generate_minimal_counterexample_enabled then
--				print ("minimizeeeee%N")
--				verifier.helper.options.set_generate_minimal_counterexample_enabled (True)
--				across verifier.helper.options.last_result.failed_verifications as fv loop
--					verifier.helper.options.set_target_feature (fv.context_feature)
--					verifier.helper.options.set_target_class (fv.context_class)
--					verifier.helper.options.set_minimization_iteration_bound (5)
--					verifier.helper.options.set_minimization_tolerance (0)
--					remaining_tasks.extend (create {E2B_VERIFY_WITH_OPTIMIZATION_TASK}.make (verifier.helper.options.last_result, verifier.helper.options.target_feature, verifier.helper.options.target_class, remaining_tasks))

--						-- TODO: handle multiple failed routines
--						-- when to end iteration?
--				end
--			end
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	verifier: attached E2B_VERIFIER
			-- Boogie verifier.

	result_generator: attached E2B_RESULT_GENERATOR
			-- Result generator.

	remaining_tasks: LINKED_LIST [ROTA_TASK_I]
			-- Tasks to work on.

	;

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
