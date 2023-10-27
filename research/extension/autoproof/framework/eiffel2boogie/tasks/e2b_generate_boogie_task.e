note
	description: "Task to translate an IV AST tree to Boogie."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_GENERATE_BOOGIE_TASK

inherit

	ROTA_TASK_I

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE; a_verifier: E2B_VERIFIER)
			-- Initialize task.
		do
			create boogie_generator.make (a_boogie_universe)
			verifier := a_verifier
			has_next_step := True
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
			-- print ("E2B_GENERATE_BOOGIE_TASK.step%N")
			boogie_generator.generate_verifier_input
			if verifier.input.context /= Void then
				boogie_generator.last_generated_verifier_input.set_context (verifier.input.context)
			end
			verifier.set_input (boogie_generator.last_generated_verifier_input)
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {E2B_VERIFY_TASK} -- Implementation

	boogie_generator: E2B_BOOGIE_GENERATOR
			-- Boogie code generator.

	verifier: E2B_VERIFIER
			-- Boogie verifier.

;note
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
