note
	description: "Wrapper for CL_TYPE_A to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CL_TYPE_A

inherit
	E2B_TYPE_A
		redefine
			make,
			type_a,
			instantiated_in
		end

create
	make


feature -- Creator
	make (a_type: CL_TYPE_A)
		do
			Precursor (a_type)
		end

feature {NONE} -- Wrapped object
	type_a: CL_TYPE_A

feature -- Wrapped features
	instantiated_in (class_type: E2B_TYPE_A): E2B_CL_TYPE_A
		do create Result.make (type_a.instantiated_in (class_type.type_a)) end

feature -- Eiffel helpers
	is_agent_type: BOOLEAN
			-- Is `t' an agent type?
		local
			l_name: like {CLASS_C}.name
		do
			l_name := base_class.name
			Result :=
				l_name.is_case_insensitive_equal ("ROUTINE") or else
				l_name.is_case_insensitive_equal ("PROCEDURE") or else
				l_name.is_case_insensitive_equal ("FUNCTION") or else
				l_name.is_case_insensitive_equal ("PREDICATE")
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
