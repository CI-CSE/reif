note
	description: "Wrapper for LIKE_FEATURE to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_LIKE_FEATURE

inherit
	E2B_TYPE_A
		redefine
			make,
			as_attached_type,
			type_a
		end

create
	make,
	make_from_params

feature -- Creator

	make_from_params (f: E2B_FEATURE_I; a_context_class_id: INTEGER)
		do type_a := create {LIKE_FEATURE}.make (f.c_feature, a_context_class_id) end

	make (a_type: LIKE_FEATURE)
		do type_a := a_type end

feature -- Redefined
	type_a: LIKE_FEATURE

feature -- Wrapped (see originals for documentation)

	as_attached_type: E2B_TYPE_A
		do create Result.make (type_a.as_attached_type) end

	set_actual_type (a: E2B_TYPE_A)
		do type_a.set_actual_type (a.type_a) end


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
