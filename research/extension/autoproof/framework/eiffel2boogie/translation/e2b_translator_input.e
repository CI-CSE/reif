note
	description: "Input to translator."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TRANSLATOR_INPUT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize empty input.
		do
			create class_list.make
			create feature_list.make
			create feature_of_type_list.make
			create class_check_list.make
		end

feature -- Acces

	class_list: attached LINKED_LIST [attached E2B_CLASS_C]
			-- List of classes to be translated.

	feature_list: attached LINKED_LIST [attached E2B_FEATURE_I]
			-- List of features to be translated.

	feature_of_type_list: attached LINKED_LIST [TUPLE [f: E2B_FEATURE_I; t: E2B_CL_TYPE_A]]
			-- List of features with a specific type to be translated.

	class_check_list: attached LINKED_LIST [E2B_CL_TYPE_A]
			-- List of classes whose class check is to be generated.

feature -- Element change

	add_class (a_class: attached E2B_CLASS_C)
			-- Add `a_class' to be translated.
		do
			class_list.extend (a_class)
		end

	add_feature (a_feature: attached E2B_FEATURE_I)
			-- Add `a_feature' to be translated.
		do
			feature_list.extend (a_feature)
		end

	add_feature_of_class (a_feature: attached E2B_FEATURE_I; a_class: E2B_CLASS_C)
		do
			add_feature_of_type (a_feature, a_class.actual_type)
		end

	add_feature_of_type (a_feature: attached E2B_FEATURE_I; a_type: E2B_CL_TYPE_A)
			-- Add `a_feature' to be translated.
		do
			feature_of_type_list.extend ([a_feature, a_type])
		end

	add_class_check (a_class: E2B_CL_TYPE_A)
			-- Add `a_class' to be translated.
		do
			class_check_list.extend (a_class)
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
