note
	description: "Wrapper for LIKE_CURRENT to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_LIKE_CURRENT

inherit
	E2B_TYPE_A
		redefine
			make,
			type_a
		end

create
	make,
	make_with_param

feature -- Creator

	make (a_type: LIKE_CURRENT)
		do type_a := a_type end

	make_with_param (a_type: E2B_TYPE_A)
		do type_a := create {LIKE_CURRENT}.make (a_type.type_a) end

feature -- Redefined
	type_a: LIKE_CURRENT

feature -- Wrapped



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
