note
	description: "Assertion clause with its origin type."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_ASSERT_ORIGIN

create
	make

feature {NONE}	-- Initialization

	make (a_clause: ASSERT_B; a_origin: E2B_CLASS_C)
			-- Create an assertion with `a_clause' coming from `a_origin'.
		require
			clause_exists: attached a_clause
			origin_exists: attached a_origin
		do
			clause := a_clause
			origin := a_origin
		ensure
			clause_set: clause = a_clause
			origin_set: origin = a_origin
		end

feature -- Access

	clause: ASSERT_B
			-- Assertion clause.

	origin: E2B_CLASS_C
			-- The class where it was defined.

invariant
	clause_exists: attached clause
	origin_exists: attached origin

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
