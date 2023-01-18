note
	description: "Interface for a platform-dependent implementation to run Boogie."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_EXECUTABLE

inherit

	E2B_SHARED_CONTEXT

feature -- Access

	input: attached E2B_VERIFIER_INPUT
			-- Input for Boogie.

	last_output: detachable STRING
			-- Output of last run of Boogie.
		deferred
		end

	last_models: detachable STRING
			-- Counterexamples of last run of Boogie.
		deferred
		end

feature -- Status report

	is_running: BOOLEAN
			-- Is process still running?
		deferred
		end

feature -- Element change

	set_input (a_input: attached E2B_VERIFIER_INPUT)
			-- Set `input' to `a_input'.
		do
			input := a_input
		ensure
			input_set: input = a_input
		end

feature -- Basic operations

	run
			-- Run Boogie on `input'.
		deferred
		ensure
			not_running: not is_running
		end

	run_asynchronous
			-- Run Boogie on `input'.
		deferred
		ensure
			maybe_running: is_running or not is_running
		end

	run_with_random_seed (a_random_seed: INTEGER)
			-- Run Boogie on `input' with `a_random_seed' asynchronously.
		deferred
		ensure
			maybe_running: is_running or not is_running
		end

	cancel
			-- Cancel execution.
		deferred
		ensure
			not_running: not is_running
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
