note
	date: "$Date$"
	revision: "$Revision$"

class
	IV_HELPER

feature -- Helper functions

	is_valid_name (a_string: READABLE_STRING_8): BOOLEAN
			-- Is `a_string' a valid name?
		do
			Result :=
				attached a_string and then
				not a_string.is_empty and then
				not a_string.has (' ') and then
				not a_string.has ('+') and then
				not a_string.has ('-') and then
				not a_string.has ('*')
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
