note
	description: "[
		Base type of translation units that translate an aspect of a feature.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_TU_FEATURE

inherit

	E2B_TRANSLATION_UNIT

feature {NONE} -- Initialization

	make (a_feature: E2B_FEATURE_I; a_context_type: E2B_CL_TYPE_A)
			-- Initialize this translation unit with feature `a_feature' and context `a_context_type'.
		do
			feat := a_feature
			type := a_context_type
			id := base_id + "/" + type_id (a_context_type) + "/" + feature_id (a_feature)
		end

feature -- Access

	base_id: STRING
			-- Base id for these types of translation units.
		deferred
		end

	id: STRING
			-- <Precursor>

	feat: E2B_FEATURE_I
			-- Feature to be translated.

	type: E2B_CL_TYPE_A
			-- Context type of feature to be translated.

;note
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
