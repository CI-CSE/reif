note
	description: "Wrapper for TYPE_A to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_TYPE_A

inherit
	HASHABLE

create
	make
feature -- Creation
	make (a_type_a: TYPE_A)
		require
			a_type_a /= Void
		do
			type_a := a_type_a
		ensure
			type_a = a_type_a
		end
feature -- Wrapped object
	type_a: TYPE_A

feature -- Wrapped features
	base_class: E2B_CLASS_C
		do create Result.make (type_a.base_class) end

	actual_type: E2B_TYPE_A
		do create Result.make (type_a.actual_type) end

	name: like type_a.name
		do Result := type_a.name end

	is_attached: like type_a.is_attached
		do Result := type_a.is_attached end

	has_associated_class: like type_a.has_associated_class
		do Result := type_a.has_associated_class end

	is_integer: like type_a.is_integer
		do Result := type_a.is_integer end

	is_boolean: like type_a.is_boolean
		do Result := type_a.is_boolean end

	is_basic: like type_a.is_basic
		do Result := type_a.is_basic end

	has_formal_generic: like type_a.has_formal_generic
		do Result := type_a.has_formal_generic end

	is_like: like type_a.is_like
		do Result := type_a.is_like end

	as_attached_type: like Current
		do create Result.make (type_a.as_attached_type) end

	same_as (other: E2B_TYPE_A): like type_a.same_as
		do Result := type_a.same_as (other.type_a) end

	is_like_current: like type_a.is_like_current
		do Result := type_a.is_like_current end

	evaluated_type_in_descendant (a_ancestor, a_descendant: E2B_CLASS_C; a_feature: E2B_FEATURE_I): E2B_TYPE_A
		local
			ancestor_class, descendant_class: CLASS_C
			l_feature: FEATURE_I
		do
			ancestor_class := if a_ancestor = Void then Void else a_ancestor.c_class end
			descendant_class := if a_descendant = Void then Void else a_descendant.c_class end
			l_feature := if a_feature = Void then Void else a_feature.c_feature end
			create Result.make (type_a.evaluated_type_in_descendant (ancestor_class, descendant_class, l_feature))
		end

	deep_actual_type: E2B_TYPE_A
		do create Result.make (type_a.deep_actual_type) end

	instantiated_in (class_type: E2B_TYPE_A): E2B_TYPE_A
		do create Result.make (type_a.instantiated_in (if class_type /= Void then class_type.type_a else Void end)) end

	associated_class_type (a_context_type: E2B_TYPE_A): CLASS_TYPE
		do Result := type_a.associated_class_type (if a_context_type /= Void then a_context_type.type_a else Void end) end

	has_associated_class_type (a_context_type: E2B_TYPE_A): BOOLEAN
		do Result := type_a.has_associated_class_type (if a_context_type /= Void then a_context_type.type_a else Void end) end

	is_class_valid: like type_a.is_class_valid
		do Result := type_a.is_class_valid end

	has_generics: like type_a.has_generics
		do Result := type_a.has_generics end

	generics: ARRAYED_LIST [E2B_TYPE_A]
		local
			i: INTEGER
		do
			if attached {ARRAYED_LIST [TYPE_A]} type_a.generics then
				create Result.make_filled (type_a.generics.count)
				check Result.count = type_a.generics.count end
				from i := Result.lower
				until i > Result.upper
				loop
					Result [i] := create {E2B_TYPE_A}.make (type_a.generics [i])
					i := i + 1
				end
			end
		end

	is_tuple: like type_a.is_tuple
		do Result := type_a.is_tuple end

	is_numeric: like type_a.is_numeric
		do Result := type_a.is_numeric end

	is_real_32: like type_a.is_real_32
		do Result := type_a.is_real_32 end

	is_real_64: like type_a.is_real_64
		do Result := type_a.is_real_64 end

	is_character: like type_a.is_character
		do Result := type_a.is_character end

	is_expanded: like type_a.is_expanded
		do Result := type_a.is_expanded end

	is_natural: like type_a.is_natural
		do Result := type_a.is_natural end

	hash_code: like type_a.hash_code
		do Result := type_a.hash_code end

	is_formal: like type_a.is_formal
		do Result := type_a.is_formal end

feature -- Ownership
	is_type_exact (a_class_type: E2B_CL_TYPE_A; a_context_feature: E2B_FEATURE_I): BOOLEAN
			-- Is `a_type' (which corresponds to `a_class_type')
			-- in the context of `a_context_feature' represent a fixed dynamic type?
		require
			class_type_exists: attached a_class_type
		do
				-- Yes, if the base class is frozen, or the type is "like Current" (provided we are not inside a dynamic feature)
			Result := a_class_type.base_class.is_frozen or
				(type_a.is_like_current and not (attached a_context_feature and then a_context_feature.is_nonvariant))
		end

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
