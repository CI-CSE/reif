note
	description: "Wrapper for CLASS_C to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_CLASS_C

inherit
	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

	E2B_SHARED_CONTEXT
		export {NONE} all end

create
	make

feature -- Creator
	make (a_class: CLASS_C)
		require
			a_class /= Void
		do
			c_class := a_class
		ensure
			c_class = a_class
		end

feature -- TODO RETO {E2B_CLASS_C, ES_AUTOPROOF_TOOL_PANEL} -- Wrapped object
	c_class: CLASS_C

feature -- Wrapper
	is_deferred: like {CLASS_C}.is_deferred
		do Result := c_class.is_deferred end

	conform_to (other: E2B_CLASS_C): like {CLASS_C}.conform_to
		do Result := c_class.conform_to (other.c_class) end

	actual_type: E2B_CL_TYPE_A
		do create Result.make (c_class.actual_type) end

	direct_descendants: ARRAYED_LIST [E2B_CLASS_C]
		local
			i: INTEGER
		do
			create Result.make_filled (c_class.direct_descendants.count)
			from i := Result.lower
			until i > Result.upper
			loop
				Result [i] := create {E2B_CLASS_C}.make (c_class.direct_descendants [i])
				i := i + 1
			end
		ensure
			same_size: c_class.direct_descendants.count = Result.count
		end

	skeleton: like {CLASS_C}.skeleton
		do Result := c_class.skeleton end

	creators: like {CLASS_C}.creators
		do Result := c_class.creators end

	feature_of_name_id (a_name_id: INTEGER): E2B_FEATURE_I
		do create Result.make (c_class.feature_of_name_id (a_name_id)) end

	name_in_upper: like {CLASS_C}.name_in_upper
		do Result := c_class.name_in_upper end

	feature_named (n: READABLE_STRING_8): detachable E2B_FEATURE_I
		do
			if attached c_class.feature_named (n) as l_named_feature then
				create Result.make (l_named_feature)
			end
		end

	feature_of_rout_id_set (rout_id_set: ROUT_ID_SET): detachable E2B_FEATURE_I
		do
			if attached c_class.feature_of_rout_id_set (rout_id_set) as l_feature then
				create Result.make (l_feature)
			end
		end

	file_name: like {CLASS_C}.file_name
		do Result := c_class.file_name end

	class_id: like {CLASS_C}.class_id
		do Result := c_class.class_id end

	name: like {CLASS_C}.name
		do Result := c_class.name end

	has_feature_table: like {CLASS_C}.has_feature_table
		do Result := c_class.has_feature_table end

	feature_table: like {CLASS_C}.feature_table
		do Result := c_class.feature_table end

	original_class: like {CLASS_C}.original_class
		do Result := c_class.original_class end

	has_creator_of_name_id (a_id: INTEGER): like {CLASS_C}.has_creator_of_name_id
		do Result := c_class.has_creator_of_name_id (a_id) end

	creation_feature: detachable E2B_FEATURE_I
		do
			if attached c_class.creation_feature as l_creation_feature then
				create Result.make (l_creation_feature)
			end
		end

	inherits_from (other: E2B_CLASS_C): like {CLASS_C}.inherits_from
		do Result := c_class.inherits_from (other.c_class) end

	invariant_feature: detachable E2B_INVARIANT_FEAT_I
		do
			if attached c_class.invariant_feature as l_invariant then
				create Result.make (l_invariant)
			end
		end

	is_any: like {CLASS_C}.is_class_any
		do Result := c_class.is_class_any end

	is_tuple: like {CLASS_C}.is_tuple
		do Result := c_class.is_tuple end

	lace_class: like {CLASS_C}.lace_class
		do Result := c_class.lace_class end

	feature_of_rout_id (a_routine_id: INTEGER): detachable E2B_FEATURE_I
		do
			if attached c_class.feature_of_rout_id (a_routine_id) as l_routine then
				create Result.make (l_routine)
			end
		end

	ast: like {CLASS_C}.ast
		do Result := c_class.ast end

	parents_classes: FIXED_LIST [E2B_CLASS_C]
		local
			i: INTEGER
		do
			create Result.make_filled (c_class.parents_classes.count)
			from i := Result.lower
			until i > Result.upper
			loop
				Result [i] := create {E2B_CLASS_C}.make (c_class.parents_classes [i])
				i := i + 1
			end
		ensure
			same_size: c_class.parents_classes.count = Result.count
		end

	append_name (a_text_formatter: TEXT_FORMATTER)
		do c_class.append_name (a_text_formatter) end

	feature_named_32 (n: STRING_32): E2B_FEATURE_I
		do create Result.make (c_class.feature_named_32 (n)) end

	is_frozen: like {CLASS_C}.is_frozen
		do Result := c_class.is_frozen end

	single_constraint (i: INTEGER): E2B_TYPE_A
		do create Result.make (c_class.single_constraint (i)) end

	update_types (data: E2B_CL_TYPE_A)
		do c_class.update_types (data.type_a) end

	parents: FIXED_LIST [E2B_CL_TYPE_A]
		local
			i: INTEGER
		do
			create Result.make_filled (c_class.parents.count)
			from i := Result.lower
			until i > Result.upper
			loop
				Result [i] := create {E2B_CL_TYPE_A}.make (c_class.parents [i])
				i := i + 1
			end
		ensure
			same_size: c_class.parents.count = Result.count
		end

	feature_of_feature_id (a_feature_id: INTEGER): E2B_FEATURE_I
		do
			create Result.make (c_class.feature_of_feature_id (a_feature_id))
		end

	feature_of_body_index (a_body_index: INTEGER): detachable E2B_FEATURE_I
		do
			if attached c_class.feature_of_body_index (a_body_index) as l_feature then
				create Result.make (l_feature)
			end
		end

	system: like {CLASS_C}.system
		do Result := c_class.system end

	non_conforming_parents_classes: detachable FIXED_LIST [E2B_CLASS_C]
		local
			i: INTEGER
		do
			if attached c_class.non_conforming_parents_classes as parent_classes then
				create Result.make_filled (parent_classes.count)
				from i := Result.lower
				until i > Result.upper
				loop
					Result [i] := create {E2B_CLASS_C}.make (parent_classes [i])
					i := i + 1
				end
			end
		ensure
			same_size: attached c_class.non_conforming_parents_classes as p implies p.count = Result.count
			else_void: not attached c_class.non_conforming_parents_classes implies Result = Void
		end

feature -- General note helpers

	class_note_values (a_tag: READABLE_STRING_8): ARRAYED_LIST [READABLE_STRING_8]
			-- List of note values of tag `a_tag'.
		do
			create Result.make (5)
			Result.compare_objects
			if attached ast as l_ast then
				if l_ast.top_indexes /= Void then
					Result.append (helper.note_values (l_ast.top_indexes, a_tag))
				end
				if l_ast.bottom_indexes /= Void then
					Result.append (helper.note_values (l_ast.bottom_indexes, a_tag))
				end
			end
		ensure
			result_attached: attached Result
		end

	boolean_class_note_value (a_tag: READABLE_STRING_8): BOOLEAN
			-- Value of a boolean feature note tag, False if not present.
		local
			l_values: like class_note_values
		do
			l_values := class_note_values (a_tag)
			if not l_values.is_empty then
				Result := l_values.i_th (1).is_case_insensitive_equal ("true")
			end
		end

	string_class_note_value (a_tag: READABLE_STRING_8): READABLE_STRING_8
			-- Value of a string class note tag, empty string if not present.
		local
			l_values: like class_note_values
		do
			Result := ""
			l_values := class_note_values (a_tag)
			if not l_values.is_empty then
				Result := l_values [1]
			end
		end

feature -- Class status helpers

	is_status (a_value: READABLE_STRING_8): BOOLEAN
			-- Does `a_class' has a note with a tag status that contains the value `a_value'?
		local
			l_values: like class_note_values
		do
			l_values := class_note_values ("status")
			if not l_values.is_empty then
				Result := across l_values as i some i.same_string (a_value) end
			end
		end

	is_skipped: BOOLEAN
			-- Is `a_class' skipped?
		do
			Result := is_status ("skip")
		end

	is_manual_inv: BOOLEAN
			-- Does `a_class' have the manual inv trigger?
		do
			Result := boolean_class_note_value ("manual_inv")
		end

	features_with_string_note_value (a_tag, a_value: READABLE_STRING_8): LINKED_LIST [E2B_FEATURE_I]
			-- Feature of class `a_class', which has a note where `a_tag' contain `a_value'.
		local
			l_feature: E2B_FEATURE_I
		do
			from
				create Result.make
				feature_table.start
			until
				feature_table.after
			loop
				l_feature := create {E2B_FEATURE_I}.make (feature_table.item_for_iteration)
				if l_feature.note_values (a_tag).has (a_value) then
					Result.extend (l_feature)
				end
				feature_table.forth
			end
		end

feature -- Logical helpers

	is_logical: BOOLEAN
			-- Is `a_class' mapped to a logical type in a Boogie theory?
		do
			Result := attached type_if_logical
		end

	type_if_logical: detachable READABLE_STRING_8
			-- Boogie type that `a_class' maps to;
			-- Void if `a_class' is not logical.
		local
			l_values: like class_note_values
		do
			l_values := class_note_values ("maps_to")
			if not l_values.is_empty then
				Result := l_values.first
			end
		end

	map_access_feature: E2B_FEATURE_I
			-- The feature of the logical class `a_class' that maps to map access in Boogie (if any).
		require
			logical_class: is_logical
		local
			l_feature: E2B_FEATURE_I
		do
			if helper.map_access_feature_cache.has_key (class_id) then
				Result := helper.map_access_feature_cache.item (class_id)
			else
				from
					feature_table.start
				until
					Result /= Void or feature_table.after
				loop
					l_feature := create {E2B_FEATURE_I}.make (feature_table.item_for_iteration)
					if attached l_feature.function_name_if_logical as n and then n.same_string ("[]") then
						Result := l_feature
					end
					feature_table.forth
				end
				helper.map_access_feature_cache.put (Result, class_id)
			end
		end

feature -- Ownership helpers

	is_explicit (a_type: READABLE_STRING_8): BOOLEAN
			-- Does `a_class' list `a_type' as explicit?
		do
			Result := across class_note_values ("explicit") as i some i.same_string (a_type) or i.same_string ("all") end
		end

	ghost_attributes: ARRAYED_LIST [E2B_FEATURE_I]
			-- All ghost attributes of `a_class' (in the order from most immediate to most inherited).
		local
			l_feature: E2B_FEATURE_I
		do
			if helper.ghost_attribute_cache.has_key (class_id) then
				Result := helper.ghost_attribute_cache [class_id]
			else
				from
					create Result.make (5)
					Result.start
					feature_table.start
				until
					feature_table.after
				loop
					l_feature := create {E2B_FEATURE_I}.make (feature_table.item_for_iteration)
					if (l_feature.is_attribute and l_feature.is_ghost) or l_feature.is_built_in_attribute then
						from
							Result.start
						until
							Result.after or else (l_feature.written_class).is_conforming_or_non_conforming_parent_class (Result.item.written_class)
						loop
							Result.forth
						end
						Result.put_left (l_feature)
					end
					feature_table.forth
				end
				helper.ghost_attribute_cache.put (Result, class_id)
			end
		end

	attribute_from_string (a_name: READABLE_STRING_8; a_type: E2B_CL_TYPE_A; a_context_feature: E2B_FEATURE_I; a_context_line_number: INTEGER): E2B_FEATURE_I
			-- Attribute or built-in ghost access with name `a_name' defined in `a_origin_class' in type `a_type'.
		local
			l_old_version: E2B_FEATURE_I
		do
			if feature_named (a_name) = Void then
				e2b_error.add_semantic_error (a_context_feature, helper.messages.unknown_attribute ({UTF_CONVERTER}.utf_8_string_8_to_string_32 (a_name), name_in_upper), a_context_line_number)
			else
				l_old_version := feature_named (a_name)
				Result := a_type.base_class.feature_of_rout_id_set (l_old_version.rout_id_set)
				check attached Result end
				if not l_old_version.is_attribute and not helper.translation_mapping.ghost_access.has (a_name) then
					e2b_error.add_semantic_error (a_context_feature, helper.messages.unknown_attribute ({UTF_CONVERTER}.utf_8_string_8_to_string_32 (a_name), name_in_upper), a_context_line_number)
				end
			end
		end

feature -- Model helpers

	model_queries: like class_note_values
			-- Names of model queries declared in class `a_class'.
		do
			Result := class_note_values ("model")
		end

	flat_model_queries: ARRAYED_LIST [E2B_FEATURE_I]
			-- Model queries declared in class `a_class' and all its ancestors.
		local
			l_f, l_new_version: E2B_FEATURE_I
		do
			if helper.flat_model_cache.has_key (class_id) then
				Result := helper.flat_model_cache [class_id]
			else
				create Result.make (5)
				if class_id = system.any_id then
--					across translation_mapping.ghost_access as m loop
--						Result.extend (a_class.feature_named_32 (m.item))
--					end
					if attached feature_named ("subjects") as f then
						Result.extend (f)
					else
						e2b_error.add_unsupported_error (Current, {STRING_32} "Feature `subjects` is not found in class `ANY`.", 0)
					end
					if attached feature_named ("observers") as f then
						Result.extend (f)
					else
						e2b_error.add_unsupported_error (Current, {STRING_32} "Feature `observers` is not found in class `ANY`.", 0)
					end
				else
					across model_queries as m loop
						l_f := feature_named (m)
						if l_f /= Void then
							Result.extend (l_f)
						else
							e2b_error.add_semantic_warning (Current, helper.messages.unknown_attribute ({UTF_CONVERTER}.utf_8_string_8_to_string_32 (m), name_in_upper), -1)
						end
					end
					across parents_classes as parent_class loop
						across parent_class.flat_model_queries as query loop
							l_new_version := feature_of_rout_id_set (query.rout_id_set)
							if not Result.has (l_new_version) then
								Result.extend (l_new_version)
							end
						end
					end
				end
				helper.flat_model_cache.put (Result, class_id)
			end
		end

	replacing_model_queries (a_feature: E2B_FEATURE_I; a_descendant: E2B_CLASS_C): ARRAYED_LIST [E2B_FEATURE_I]
			-- All model queries that represent `a_feature' from `a_class'
			-- in `a_class' and its descendants down to `a_descendant',
			-- as seen in `a_descendant'.
		require
			feature_exists: attached a_feature
			feature_is_model: is_model_query (a_feature)
		local
			l_new_version: E2B_FEATURE_I
			l_rep_features: LINKED_LIST [E2B_FEATURE_I]
		do
			create Result.make (5)
			Result.extend (a_descendant.feature_of_rout_id_set (a_feature.rout_id_set))
			across direct_descendants as descendant loop
				if a_descendant.inherits_from (descendant) then
					l_new_version := descendant.feature_of_rout_id_set (a_feature.rout_id_set)
					if descendant.model_queries.has (l_new_version.feature_name) then
						create l_rep_features.make
						l_rep_features.extend (l_new_version)
					else
						l_rep_features := descendant.features_with_string_note_value ("replaces", l_new_version.feature_name)
					end
					across l_rep_features as rep_f loop
						across descendant.replacing_model_queries (rep_f, a_descendant) as q loop
							if not Result.has (q) then
								Result.extend (q)
							end
						end
					end
				end
			end
		end

	is_model_query (a_feature: E2B_FEATURE_I): BOOLEAN
			-- Is `a_feature' an immediate or inherited model query of `a_class'?
		do
			Result := across flat_model_queries as f some a_feature.is_same_feature (f) end
		end

feature -- Eiffel helpers

	constraint_type: E2B_CL_TYPE_A
			-- Type based on `a_class' without formal generic parameters.
		local
			new_generics: like {CL_TYPE_A}.generics
			result_type: GEN_TYPE_A
		do
			Result := actual_type
			if
				attached {GEN_TYPE_A} Result.type_a as generic_type and then
				attached generic_type.generics as old_generics
			then
				across
					old_generics as l_generic
				loop
					if l_generic.is_formal then
						if not attached new_generics then
							new_generics := old_generics.twin
							result_type := generic_type.twin
							result_type.set_generics (new_generics)
							Result := create {E2B_CL_TYPE_A}.make (result_type)
						end
						new_generics [@ l_generic.target_index] := generic_type.base_class.single_constraint (@ l_generic.target_index)
					end
				end
			end
			update_types (Result)
		end

	is_same_class (c2: E2B_CLASS_C): BOOLEAN
			-- Ais_same_classre `c1' and `c2' the same class?
		do
			Result := c_class = c2.c_class or
				(c2 /= Void and then class_id = c2.class_id)
		end

	is_array: BOOLEAN
			-- Is `c' the ARRAY class?
		do
			Result := class_id = system.array_id
		end

	is_conforming_or_non_conforming_parent_class (a_parent: E2B_CLASS_C): BOOLEAN
			-- Does `a_child' inherit conforminlgy or non-conformingly from `a_parent'?
		do
			Result := conform_to (a_parent) or else is_non_conforming_parent_class (a_parent)
		end

	is_non_conforming_parent_class (a_parent: E2B_CLASS_C): BOOLEAN
			-- Does `a_child' inherit non-conformingly from `a_parent'?
		local
			l_item: E2B_CLASS_C
		do
			if non_conforming_parents_classes /= Void then
				from
					non_conforming_parents_classes.start
				until
					non_conforming_parents_classes.after or Result
				loop
					l_item := non_conforming_parents_classes.item
					Result := l_item.class_id = a_parent.class_id or else l_item.is_conforming_or_non_conforming_parent_class (a_parent)
					non_conforming_parents_classes.forth
				end
			end
		end

	class_type (a_context_type: E2B_CL_TYPE_A): E2B_CL_TYPE_A
			-- Type of ancetor `a_class' in `a_context_type'.
		do
			Result := class_type_in_context (actual_type, Void, a_context_type)
		end

	class_type_in_context (a_type: E2B_TYPE_A; a_feature: E2B_FEATURE_I; a_current_type: E2B_CL_TYPE_A): E2B_CL_TYPE_A
			-- Class type `a_type', which comes from `an_ancestor_class' (with optional `a_feature') as seen from `a_current_type'.
		require
			no_formals: not a_current_type.has_formal_generic
		local
			l_type: E2B_TYPE_A
		do
			if a_type.is_like_current then
				Result := a_current_type
			else
					-- `evaluated_type_in_descendant' switches to the correct feature in case of LIKE_FEATURE types
					-- `deep_actual_type' gets rid of like types
					-- `instantiated_in (a_current_type)' instantiates the generics
				l_type := a_type.evaluated_type_in_descendant
						(Current, a_current_type.base_class, a_feature).deep_actual_type.instantiated_in
						(a_current_type)
				if attached {CL_TYPE_A} l_type.type_a as l_class_type then
					create Result.make (l_class_type)
				elseif
					attached {FORMAL_A} a_type.type_a as l_formal_type and then
					attached {CL_TYPE_A} a_current_type.base_class.single_constraint (l_formal_type.position).type_a as l_class_type
				then
					create Result.make (l_class_type)
				else
					check class_type_constraint: False then end
				end
			end
		ensure
			no_formals: not Result.has_formal_generic
		end

feature -- other
	verify_feature (a_feature: E2B_FEATURE_I): BOOLEAN
			-- Should `a_feature' be verified as part of verification of `Current'?
		do
			Result := a_feature.is_routine and -- is routine
				not a_feature.is_logical and -- not logical
				not a_feature.is_skipped and -- not feature skipped
				not is_skipped and -- not class skipped
				(a_feature.written_in /= system.any_id or a_feature.rout_id_set.has (system.default_create_rout_id)) and -- is not inherited from ANY
				not (a_feature.written_in /= class_id and a_feature.is_nonvariant) -- not an inherited nonvariant feature
		end

invariant
	class_not_void: c_class /= Void

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
