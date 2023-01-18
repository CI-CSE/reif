note
	description: "Result of verifying a Boogie program."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_BOOGIE_RESULT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize result.
		do
			create boogie_errors.make
			create procedure_results.make
		end

feature -- Access

	boogie_version: STRING
			-- Boogie version.

	boogie_errors: LINKED_LIST [STRING]
			-- List of Boogie errors.

	procedure_results: LINKED_LIST [E2B_BOOGIE_PROCEDURE_RESULT]
			-- List of procedure results.

	input_text: LIST [STRING]
			-- Input text to Boogie.

feature -- Element change

	set_boogie_version (a_value: STRING)
			-- Set `boogie_version' to `a_value'.
		do
			boogie_version := a_value.twin
		end

	set_input_text (a_text: LIST [STRING])
			-- Set `input_text' to `a_text'
		do
			input_text := a_text
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
