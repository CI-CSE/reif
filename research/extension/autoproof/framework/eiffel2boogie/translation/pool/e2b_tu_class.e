note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_CLASS

inherit

	E2B_TRANSLATION_UNIT

create
	make

feature {NONE} -- Implementation

	make (a_class_type: CL_TYPE_A)
			-- Initialize translation unit for class `a_class'.
		do
			class_type := a_class_type
			id := "class/" + a_class_type.base_class.name_in_upper
		end

feature -- Access

	class_type: CL_TYPE_A
			-- Type to be translated.

	id: STRING
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_type_translator: E2B_TYPE_TRANSLATOR
		do
			create l_type_translator
			l_type_translator.generate_invariant_admissability_check (class_type)
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
