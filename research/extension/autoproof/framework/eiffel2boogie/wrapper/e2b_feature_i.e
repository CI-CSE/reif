note
	description: "Wrapper for FEATURE_I to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FEATURE_I

inherit
	HASHABLE
	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

	IV_SHARED_TYPES
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	E2B_SHARED_CONTEXT
		export {NONE} all
		redefine
			set_up_byte_context,
			switch_byte_context
		end

create
	make

feature -- Creator
	make (a_feature: FEATURE_I)
		require
			a_feature /= Void
		do
			c_feature := a_feature
		ensure
			c_feature = a_feature
		end

feature {E2B_FEATURE_I, E2B_CLASS_C, E2B_TYPE_A, E2B_SHARED_CONTEXT, E2B_BLACKBOARD_RESULT} -- Wrapped object
	c_feature: FEATURE_I

feature
	name_of_local (pos: INTEGER): STRING
			-- Name of local at position `pos`
		local
			i: INTEGER
		do
			if attached c_feature.real_body as b
				and then attached b.as_routine as r
				and then attached r.locals as locals
				then
				-- Walk the `local` AST node and get the `pos`th variable name
				across locals as dec until i = pos loop
					across dec.id_list as var_id until i = pos loop
						i := i + 1

						if i = pos then
							Result := dec.item_name (@ var_id.cursor_index)
						end
					end
				end
			end
			if Result = Void then
				Result := "local_#" + pos.out
			end
		end

feature -- wrapped features (see originals for documentation)

	written_in: like {FEATURE_I}.written_in
		do Result := c_feature.written_in end

	body: like {FEATURE_I}.body
		do Result := c_feature.body end

	is_deferred: like {FEATURE_I}.is_deferred
		do Result := c_feature.is_deferred end

	is_attribute: like {FEATURE_I}.is_attribute
		do Result := c_feature.is_attribute end

	is_routine: like {FEATURE_I}.is_routine
		do Result := c_feature.is_routine end

	is_constant: like {FEATURE_I}.is_constant
		do Result := c_feature.is_constant end

	arguments: detachable FEAT_ARG
		do
			Result := c_feature.arguments
		ensure
			c_feature.arguments /= Void ⇒ Result.count = c_feature.arguments.count
		end

	rout_id_set: like {FEATURE_I}.rout_id_set
		do Result := c_feature.rout_id_set end

	feature_name_32: like {FEATURE_I}.feature_name_32
		do Result := c_feature.feature_name_32 end

	body_index: like {FEATURE_I}.body_index
		do Result := c_feature.body_index end

	written_class: E2B_CLASS_C
		do create Result.make (c_feature.written_class) end

	type: E2B_TYPE_A
		do create Result.make (c_feature.type) end

	e_feature: like {FEATURE_I}.e_feature
		do Result := c_feature.e_feature end

	feature_name: like {FEATURE_I}.feature_name
		do Result := c_feature.feature_name end

	has_return_value: like {FEATURE_I}.has_return_value
		do Result := c_feature.has_return_value end

	argument_count: like {FEATURE_I}.argument_count
		do Result := c_feature.argument_count end

	feature_id: like {FEATURE_I}.feature_id
		do Result := c_feature.feature_id end

	instantiated (parent_type: E2B_TYPE_A): E2B_FEATURE_I
		do create Result.make (c_feature.instantiated (parent_type.type_a)) end

	has_arguments: like {FEATURE_I}.has_arguments
		do Result := c_feature.has_arguments end

	assert_id_set: like {FEATURE_I}.assert_id_set
		do Result := c_feature.assert_id_set end

	is_once: like {FEATURE_I}.is_once
		do Result := c_feature.is_once end

	feature_name_id: like {FEATURE_I}.feature_name_id
		do Result := c_feature.feature_name_id end

	is_external: like {FEATURE_I}.is_external
		do Result := c_feature.is_external end

	api_feature (a_class_id: INTEGER): like {FEATURE_I}.api_feature
		do Result := c_feature.api_feature (a_class_id) end

	has_postcondition: like {FEATURE_I}.has_postcondition
		do Result := c_feature.has_postcondition end

	written_type (class_type: CLASS_TYPE): like {FEATURE_I}.written_type
		do Result := c_feature.written_type (class_type) end

	has_precondition: like {FEATURE_I}.has_precondition
		do Result := c_feature.has_precondition end

	is_exported_for (client: E2B_CLASS_C): like {FEATURE_I}.is_exported_for
		do Result := c_feature.is_exported_for (client.c_class) end

	export_status: like {FEATURE_I}.export_status
		do Result := c_feature.export_status end

feature {NONE}
	hash_code: INTEGER
		do
			if attached {HASHABLE} c_feature as h then
				Result := h.hash_code
			end
		end

feature -- General note helpers
	note_values (a_tag: READABLE_STRING_8): ARRAYED_LIST [READABLE_STRING_8]
			-- List of note values of tag `a_tag'.
		do

			if body /= Void and then body.indexes /= Void then
				Result := helper.note_values (body.indexes, a_tag)
			else
				create Result.make (0)
			end
		ensure
			result_attached: attached Result
		end

	boolean_note_value (a_tag: READABLE_STRING_8): BOOLEAN
			-- Value of a boolean feature note tag, False if not present.
		local
			l_values: like note_values
		do
			l_values := note_values (a_tag)
			if not l_values.is_empty then
				Result := l_values.i_th (1).is_case_insensitive_equal ("true")
			end
		end

	integer_note_value (a_tag: READABLE_STRING_8): INTEGER
			-- Value of an integer feature note tag, -1 if not present.
		local
			l_values: like note_values
		do
			Result := -1
			l_values := note_values (a_tag)
			if not l_values.is_empty and then l_values.i_th (1).is_integer then
				Result := l_values.i_th (1).to_integer
			end
		end

	string_note_value (a_tag: READABLE_STRING_8): READABLE_STRING_8
			-- Value of a string feature note tag, empty string if not present.
		local
			l_values: like note_values
		do
			Result := ""
			l_values := note_values (a_tag)
			if not l_values.is_empty then
				Result := l_values [1]
			end
		end

feature -- Feature status helpers

	is_status (a_value: READABLE_STRING_8): BOOLEAN
			-- Does `Current' has a feature note with a tag status that contains the value `a_value'?
		local
			l_values: like note_values
		do
			l_values := note_values ("status")

			if not l_values.is_empty then
				Result := across l_values as i some i.same_string (a_value) end
			end
		end

	is_creator: BOOLEAN
			-- Is `Current' a creator?
		do
			Result := is_status ("creator")
		end

	is_nonvariant: BOOLEAN
			-- Is `Current' nonvariant (i.e. does not know the dynmaic type of Current)?
		do
			Result := not helper.options.is_ignoring_nonvariant and then is_status ("nonvariant")
		end

	is_functional: BOOLEAN
			-- Is `Current' a functional feature?
		do
			Result := is_status ("functional")
		end

	is_ghost: BOOLEAN
			-- Is `Current' a ghost feature?
		do
			Result := is_status ("ghost") or written_class.is_status ("ghost")
		end

	is_impure: BOOLEAN
			-- Is `Current' impure?
		do
			Result := is_status ("impure")
		end

	is_inline_in_caller: BOOLEAN
			-- Is `Current' inlined in caller?
		do
			Result := is_status ("inline_in_caller")
		end

	is_invariant_unfriendly: BOOLEAN
			-- Is `Current' invariant unfriendly?
		do
			Result := is_status ("inv_unfriendly")
		end

	is_lemma: BOOLEAN
			-- Is `Current' a lemma?
		do
			Result := is_status ("lemma")
		end

	is_manual_inv: BOOLEAN
			-- Does `Current' have the manual inv trigger?
		do
			Result := boolean_note_value ("manual_inv")
		end

	is_opaque: BOOLEAN
			-- Is `Current' an opaque function (its definition is not automatically available)?
		do
			Result := is_status ("opaque")
		end

	is_static: BOOLEAN
			-- Is `Current' a static feature (it does not take Current as argument)?
		do
			Result := is_status ("static") or c_feature.has_class_postcondition
		end

	is_private: BOOLEAN
			-- Is `Current' a private feature?
		do
			Result := export_status.is_none
		end

	is_public: BOOLEAN
			-- Is `Current' a public feature?
		do
			Result := is_exported_for (create {E2B_CLASS_C}.make (helper.system.any_class.compiled_class))
		end

	is_setter: BOOLEAN
			-- Is `Current' a setter?
		do
			Result := is_status ("setter")
		end

	is_skipped: BOOLEAN
			-- Is `Current' skipped for verification?
		do
			Result := is_status ("skip")
		end

	has_functional_representation: BOOLEAN
			-- Will a Boogie function be generated for `Current'?
		do
			Result := has_return_value and not is_impure
		end

feature -- Logical helpers
	is_logical: BOOLEAN
			-- Is `Current' directly mapped to a Boogie function?
		do
			Result := written_class.is_logical and not is_lemma
		end

	function_name_if_logical: detachable READABLE_STRING_8
			-- Boogie function that `Current' maps to;
			-- Void if `Current' is not from a logical class.
		local
			l_values: like note_values
		do
			if written_class.is_logical then
				l_values := note_values ("maps_to")
				if l_values.is_empty then
						-- Use standard naming scheme
					Result := written_class.type_if_logical + "#" + helper.to_camel_case (feature_name)
				else
					Result := l_values.first
				end
			end
		end

feature -- Ownership helpers
	is_feature_explicit (a_type: STRING): BOOLEAN
		do
			Result := across note_values ("explicit") as i some i.same_string (a_type) or i.same_string ("all") end
		end

	is_explicit (a_type: STRING): BOOLEAN
			-- Does either of the following hold?
			-- 1. ownership defaults are disabled
			-- 2. `Current' list `a_type' as explicit
			-- 3. `Current' marks all as explicit
			-- 4. the class of `Current' list `a_type' as explicit
			-- 5. the class of `Current' marks all as explicit
		do
			Result :=
				not options.is_ownership_defaults_enabled or else
				is_feature_explicit (a_type) or else
				written_class.is_explicit (a_type)
		end

	boogie_name_for_attribute (a_context_type: E2B_CL_TYPE_A): READABLE_STRING_8
			-- Name of the boogie tranlsation of `Current', taking special translation of built-ins into account.
		do
			Result := feature_name
			if not helper.translation_mapping.ghost_access.has (Result) then
				Result := helper.name_translator.boogie_procedure_for_feature (Current, a_context_type)
			end
		end

	guards_for_attribute: LINKED_LIST [TUPLE [str: READABLE_STRING_8; origin: E2B_CLASS_C]]
			-- Update guard for attribute `Current'.
		local
			guard_note: READABLE_STRING_8
			l_class: E2B_CLASS_C
		do
			create Result.make
			Result.compare_objects
			across all_versions as ver loop
				guard_note := ver.string_note_value ("guard")
				l_class := ver.written_class
				if guard_note.is_empty then
						-- No guard defined
					if ver.assert_id_set = Void then
							-- This is the original version: apply default
						if l_class.boolean_class_note_value ("false_guards") then
							Result.extend (["false", l_class])
						else
							Result.extend (["inv", l_class])
						end
					else
							-- This is a redefinition: skip (equivalent to adding true)
					end
				else
						-- Explicit guard: add to list
					Result.extend (guard_note, l_class)
				end
			end
		ensure
			non_empty: not Result.is_empty
			each_non_empty: across Result as s all not s.str.is_empty end
		end

	field_from_attribute (a_context_type: E2B_CL_TYPE_A): IV_ENTITY
			-- Boogie field entity that corresponds to attribute (or built-in ghost access) `Current' in `a_context_type'.
		local
			l_type: E2B_CL_TYPE_A
		do
			if helper.translation_mapping.ghost_access.has (feature_name) then
					-- Handle built-in ANY attributes separately, since they are not really attributes.
				create Result.make (feature_name, types.field (helper.translation_mapping.ghost_access_type (feature_name)))
			else
				check is_attribute end
				l_type := (a_context_type.base_class).class_type_in_context (type, Void, a_context_type)
				create Result.make (helper.name_translator.boogie_procedure_for_feature (Current, a_context_type),
					types.field (types.for_class_type (l_type)))
				helper.translation_pool.add_referenced_feature (Current, a_context_type)
			end
		end

	is_built_in_attribute: BOOLEAN
			-- Does `Current' represent on the of the built-in attributes?
			-- (Which means that it is not actually an attribute, but should be).
		do
				-- ToDo: take possible renaming into account?
			Result := helper.translation_mapping.ghost_access.has (feature_name)
		end
feature -- Model helpers
	replaced_model_queries (a_descendant: E2B_CLASS_C): ARRAYED_LIST [E2B_FEATURE_I]
			-- All features replaced by all version of `Current' in `a_type',
			-- as seen from `a_descendant'.
		local
			l_rep_clause: ARRAYED_LIST [READABLE_STRING_8]
			l_rep_feature: E2B_FEATURE_I
		do
			create Result.make (5)
			across all_versions as vers loop
				l_rep_clause := vers.note_values ("replaces")
				across l_rep_clause as f loop
					l_rep_feature := vers.written_class.feature_named (f)
					if attached l_rep_feature then
						Result.extend (a_descendant.feature_of_rout_id_set (l_rep_feature.rout_id_set))
						across l_rep_feature.replaced_model_queries (a_descendant) as q loop
							if not Result.has (q) then
								Result.extend (q)
							end
						end
					end
				end
			end
		end

feature -- String helpers

	is_creator_of_class (a_class: E2B_CLASS_C): BOOLEAN
			-- Is `Current' a creator of `a_class'?
		do
			Result := a_class.has_creator_of_name_id (feature_name_id) or
				(a_class.creation_feature /= Void and then a_class.creation_feature.feature_id = feature_id)

			if a_class.creation_feature /= Void then
					-- default create
			elseif a_class.has_creator_of_name_id (feature_name_id) then

					-- push it into a HASHTABLE[ARRAY[FEATURE_I], a_class]

					-- use the first creation procedure by default?
					-- user defined creation procedure?
					-- how to store this information?
			end
		end

feature -- Eiffel helpers

	is_same_feature (f2: E2B_FEATURE_I): BOOLEAN
			-- Are `Current' and `f2' the same feature?
		do
			Result := c_feature = f2.c_feature or
				(written_in = f2.written_in ∧ rout_id_set.first = f2.rout_id_set.first)
		end

	all_versions: LINKED_LIST [E2B_FEATURE_I]
			-- All written versions of `Current'.
		local
			l_written_feature: E2B_FEATURE_I
			i: INTEGER
		do
			create Result.make
				-- Add the written version of the feature
			l_written_feature := written_class.feature_of_body_index (body_index)
			Result.extend (l_written_feature)
			if assert_id_set /= Void then
					-- Redefined feature: return original versions
				from
					i := 1
				until
					i > assert_id_set.count
				loop
					create l_written_feature.make (assert_id_set [i].written_class.feature_of_body_index (assert_id_set [i].body_index))
					Result.extend (l_written_feature)
					i := i + 1
				end
			end
		end

feature -- Contract helpers

	has_flat_precondition: BOOLEAN
			-- Could `Current' have a precondition (immediate or inherited)?
		do
			Result := has_precondition or assert_id_set /= Void
		end

feature -- Byte context helper
	set_up_byte_context (a_type: E2B_TYPE_A)
			-- Set up byte context for `Current' of type `a_type'.
		do
				-- Clear byte context
			Context.clear_feature_data
			Context.clear_class_type_data
			Context.inherited_assertion.wipe_out

				-- Set up class type
			if not a_type.has_associated_class_type (Void) then
				if attached {CL_TYPE_A} a_type.type_a as l_cl_type_a then
					a_type.base_class.update_types (create {E2B_CL_TYPE_A}.make (l_cl_type_a))
				else
					check False end
				end
			end
			check a_type.has_associated_class_type (Void) end
			Context.init (a_type.associated_class_type (Void))

				-- Set up feature data
			Context.set_class_type (written_type (a_type.associated_class_type (Void)))
			Context.set_current_feature (Current.c_feature)
			if byte_server.has (body_index) then
				Context.set_byte_code (byte_server.item (body_index))
			end
		end

	switch_byte_context (a_target_type: E2B_CL_TYPE_A; a_written_type: E2B_CL_TYPE_A)
			-- Update byte context to feature `Current` written in `a_written_type` called on type `a_target_type`.
			-- Use `unswitch_byte_context` to restore original state.
		local
			l_current_feature: detachable E2B_FEATURE_I
		do
			Context.change_class_type_context
				(a_target_type.associated_class_type (Void),
				a_target_type.type_a,
				a_written_type.associated_class_type (Void),
				a_written_type.type_a)
			if attached Context.current_feature as att_feature then
				create l_current_feature.make (att_feature)
			end
			helper.context_stack.put ([l_current_feature, Context.byte_code])
			Context.set_current_feature (Current.c_feature)
			if byte_server.has (body_index) then
				Context.set_byte_code (byte_server.item (body_index))
			end
		end

feature -- Other

	is_inlining_routine: BOOLEAN
			-- Should routine `Current' be inlinied?
		do
			Result := helper.options.is_inlining_enabled and then
				is_inline_in_caller
			if not Result and helper.options.is_automatic_inlining_enabled then
				Result := not
						(has_postcondition or else
							attached assert_id_set as a and then a.has_postcondition)
			end
			if not Result then
				Result := helper.options.routines_to_inline.has (body_index)
			end
		end

invariant
	feature_not_void: c_feature /= Void

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
