note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_DECLARATION

feature -- Status report

	is_built_in: BOOLEAN
			-- Is this declaration built-in in background theory?

feature -- Status setting

	set_built_in
			-- Set `is_built_in' to True.
		do
			is_built_in := True
		ensure
			is_built_in: is_built_in
		end

feature -- Visitor

	process (a_visitor: IV_UNIVERSE_VISITOR)
			-- Process `a_visitor'.
		deferred
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
