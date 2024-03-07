note
	description: "[
		The basic unit of translation.
		Denotes an element that has to be translated to Boogie.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_TRANSLATION_UNIT

inherit
	E2B_SHARED_CONTEXT
	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

feature -- Access

	id: STRING
			-- Unique ID of this translation unit.
		deferred
		end

feature -- Basic operations

	translate
			-- Translate this unit.
		deferred
		end

feature {NONE} -- Helper functions

	type_id (a_type: E2B_CL_TYPE_A): STRING
			-- Id for type `a_type'.
		local
			i: INTEGER
			t: E2B_TYPE_A
		do
			if attached {GEN_TYPE_A} a_type.type_a as l_gen_type then
				Result := l_gen_type.base_class.name_in_upper.twin
				Result.append ("^")
				from
					i := l_gen_type.generics.lower
				until
					i > l_gen_type.generics.upper
				loop
					t := create {E2B_TYPE_A}.make (l_gen_type.generics [i])
					if attached {E2B_CL_TYPE_A} t as c then
						Result.append (type_id (c))
					elseif attached {E2B_CL_TYPE_A} l_gen_type.base_class.single_constraint (i) as c then
						Result.append (type_id (c))
					else
						check class_type_constraint: False then end
					end
					if i < l_gen_type.generics.upper then
						Result.append ("#")
					end
					i := i + 1
				end
				Result.append ("^")
			else
				Result := a_type.base_class.name_in_upper.twin
			end
		end

	feature_id (a_feature: E2B_FEATURE_I): STRING
			-- Id for feature `a_feature'.
		do
			Result := a_feature.feature_name
-- TODO: use body index to account for renaming
--			Result := "f-body-" + a_feature.body_index.out
			;(create {REFACTORING_HELPER}).fixme ("use body index to account for renaming")
		end

invariant
	id_attached: attached id
	id_valid: not id.is_empty

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
