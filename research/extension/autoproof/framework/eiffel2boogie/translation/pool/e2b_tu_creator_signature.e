note
	description: "[
		Translation unit for the signature of a creation routine.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TU_CREATOR_SIGNATURE

inherit

	E2B_TU_FEATURE

	SHARED_WORKBENCH

create
	make

feature -- Access

	base_id: STRING = "creator-signature"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			if feat.feature_name_id = {PREDEFINED_NAMES}.default_create_name_id and feat.written_in = system.any_id then
				l_translator.translate_default_create_signature (feat, type)
			else
				l_translator.translate_creator_signature (feat, type)
			end
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
