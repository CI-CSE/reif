note
	description: "[
		Individual verifiation error.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_VERIFICATION_ERROR

feature {NONE} -- Initialization

	make (a_parent: E2B_VERIFICATION_RESULT)
			-- Initialize verification error.
		do
			verification_result := a_parent
		end

feature -- Access

	verification_result: E2B_VERIFICATION_RESULT
			-- Related verification result.

	context_feature: detachable FEATURE_I
			-- Related Eiffel feature (if any).
		do
			Result := verification_result.context_feature
		end

	context_class: detachable CLASS_C
			-- Related Eiffel class (if any).
		do
			Result := verification_result.context_class
		end

	context_line_number: INTEGER
			-- Related Eiffel line number (if any).

	ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE
			-- Initial state extracted from the corresponding counterexample

	ce_message: STRING
			-- Message for displaying counterexample.

feature -- Display

	set_ce_init_state (a_ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE)
			-- Set `ce_init_state' to `a_init_state'.
		do
			ce_init_state := a_ce_init_state
			-- print("ce_message: " + ce_message + "%N")
		end

	set_ce_message (a_ce_message: STRING)
			-- Set `message' to `a_message'.
		do
			ce_message := a_ce_message
			-- print("ce_message: " + ce_message + "%N")
		end

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this error.
		deferred
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- Multi line description of this error.
		do
			single_line_message (a_formatter)
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
