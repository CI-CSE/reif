note
	description: "Base class for feature translators."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_FEATURE_TRANSLATOR

inherit

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

	SHARED_NAMES_HEAP

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

feature -- Access

	current_feature: E2B_FEATURE_I
			-- Currently translated feature.

	current_type: E2B_CL_TYPE_A
			-- Context type of the currently translated feature.

feature -- Element change

	set_context (a_feature: E2B_FEATURE_I; a_type: E2B_CL_TYPE_A)
			-- Set context of current translation.
		do
			current_feature := a_feature
			current_type := if a_type.is_attached then a_type else a_type.as_attached_type end
		ensure
			current_feature_set: current_feature = a_feature
			current_type_set: current_type.same_as (if a_type.is_attached then a_type else a_type.as_attached_type end)
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
