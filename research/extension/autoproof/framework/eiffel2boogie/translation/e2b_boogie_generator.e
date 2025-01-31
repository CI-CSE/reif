note
	description: "Generate Boogie code from IV universe."

class
	E2B_BOOGIE_GENERATOR

create
	make

feature {NONE} -- Initialization

	make (a_boogie_universe: IV_UNIVERSE)
			-- Initialize Boogie generator with universe `a_boogie_universe'.
		do
			boogie_universe := a_boogie_universe
			create l_context
		ensure
			boogie_universe_set: boogie_universe = a_boogie_universe
		end

feature -- Access

	boogie_universe: IV_UNIVERSE
			-- Boogie universe.

	last_generated_verifier_input: E2B_VERIFIER_INPUT
			-- Verifier input generated from `iv_universe'.

	l_context: E2B_SHARED_CONTEXT
			-- Shared context for translation

feature -- Basic operations

	generate_verifier_input
			-- Generate verifier input for `boogie_universe'.
		local
			l_printer: IV_BOOGIE_PRINTER
		do
			create last_generated_verifier_input.make

				-- Add universe dependencies
			across
				boogie_universe.dependencies as deps
			loop
				last_generated_verifier_input.add_boogie_file (deps)
			end

				-- Add background theory
			last_generated_verifier_input.add_boogie_file (theory_directory.extended ("base_theory.bpl"))

			if l_context.options.is_full_coverage_test_generation_enabled or l_context.options.is_full_mcdc_test_generation_enabled then
				create {IV_BOOGIE_SEEDED_CONTRADICTION_PRINTER} l_printer.make
			else
				create l_printer.make
			end

			boogie_universe.process (l_printer)
			last_generated_verifier_input.add_custom_content (l_printer.output.out)
		end

feature {E2B_CUSTOM_AGENT_CALL_HANDLER} -- Implementation

	theory_directory: PATH
			-- Directory containing theory files.
		once
			if {EIFFEL_LAYOUT}.is_eiffel_layout_defined then
				Result := {EIFFEL_LAYOUT}.eiffel_layout.tools_path.extended ("autoproof")
			else
				create Result.make_current
			end
		ensure
			instance_free: class
		end

note
	date: "$Date: 2022-01-19 03:46:44 +0800 (Wed, 19 Jan 2022) $"
	revision: "$Revision: 106120 $"
	copyright:
		"Copyright (c) 2012-2014 ETH Zurich",
		"Copyright (c) 2018-2019 Politecnico di Milano",
		"Copyright (c) 2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Nadia Polikarpova", "Alexander Kogtenkov"
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
