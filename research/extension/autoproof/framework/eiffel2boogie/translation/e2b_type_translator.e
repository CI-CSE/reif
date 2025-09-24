note
	description: "Translation of Eiffel types to Boogie."

class
	E2B_TYPE_TRANSLATOR

inherit

	E2B_SHARED_CONTEXT

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

feature -- Access

	type: E2B_CL_TYPE_A
			-- Type under translation.

	last_clauses: LINKED_LIST [IV_ASSERT]
			-- Last generated invariant clauses.

	last_safety_checks: LINKED_LIST [IV_ASSERT]
			-- Last generated precondition of the invariant.

	builtin_collector: E2B_BUILTIN_CALLS_COLLECTOR
			-- Visitor that collects information about the usage of built-in ghost fields.

feature -- Basic operations

	translate_type (a_type: E2B_CL_TYPE_A)
			-- Translate `a_type' to Boogie.
		require
			no_formals: not a_type.has_formal_generic
		local
			l_class: E2B_CLASS_C
			l_boogie_type_name: STRING
			l_constant: IV_CONSTANT
			l_path: PATH
			l_attr_translator: E2B_ATTRIBUTE_TRANSLATOR
			l_routine_translator: E2B_ROUTINE_TRANSLATOR

		do
			type := a_type
			l_class := a_type.base_class
			l_boogie_type_name := name_translator.boogie_name_for_type (a_type)

				-- Add dependencies
			across
				l_class.class_note_values ("theory") as deps
			loop
				create l_path.make_from_string (deps)
				boogie_universe.add_dependency
					(if l_path.is_absolute then
						l_path
					else
						l_path.absolute_path_in (l_class.lace_class.file_name.parent).canonical_path
					end)
			end

				-- Add declaration of bn if test generation is enabled
			if helper.options.is_full_coverage_test_generation_enabled and boogie_universe.constant_named ("bn") = Void then
				boogie_universe.add_declaration (create {IV_CONSTANT}.make ("bn", types.int))
			end

				-- Add actual generic parameters
			if a_type.has_generics then
				across a_type.generics as params loop
					if attached {CL_TYPE_A} params.type_a as t then
						translation_pool.add_parent_type (create {E2B_CL_TYPE_A}.make (t))
					elseif attached {CL_TYPE_A} a_type.base_class.single_constraint (@ params.target_index).type_a as t then
						translation_pool.add_parent_type (create {E2B_CL_TYPE_A}.make (t))
					else
						check class_type_constraint: False then end
					end
				end
			end

			if not l_class.is_logical then
					-- Type definition
				create l_constant.make (l_boogie_type_name, types.type)
				l_constant.set_unique
				boogie_universe.add_declaration (l_constant)
				if l_class.is_tuple then
						-- Translate fields
					create l_attr_translator
					across a_type.generics as params loop
						l_attr_translator.translate_tuple_field (a_type, @ params.target_index)
					end

						-- Tranlsate creator
					create l_routine_translator.make
					l_routine_translator.translate_tuple_creator (a_type)
				else
					if a_type.base_class.is_frozen then
						boogie_universe.add_declaration (create {IV_AXIOM}.make (
							factory.function_call ("is_frozen", <<factory.entity (l_boogie_type_name, types.type)>>, types.bool)))
					end

						-- Inheritance relations
					generate_inheritance_relations
				end
				add_default_field_ids
				translate_is_initialized_with_default
			end
		end

	translate_model (a_type: E2B_CL_TYPE_A)
			-- Translate model of `a_type'.
		require
			a_type_exists: a_type /= Void
		local
			l_class: E2B_CLASS_C
		do
			type := a_type
			l_class := type.base_class
			if not l_class.is_logical and not l_class.is_tuple then
					-- Check model clause
				across
					l_class.model_queries as m
				loop
					if a_type.base_class.feature_named (m) = Void then
						e2b_error.add_semantic_error (l_class, messages.unknown_attribute ({UTF_CONVERTER}.utf_8_string_8_to_string_32 (m), l_class.name_in_upper), -1)
					end
				end
				generate_model_axiom
			end
		end

	translate_filtered_invariant_function (a_type: E2B_CL_TYPE_A; a_included, a_excluded: LIST [STRING]; a_ancestor: E2B_CLASS_C)
			-- Translate filtered invariant of `a_type'.
		require
			a_type_exists: a_type /= Void
			a_ancestor_exists: a_ancestor /= Void
			not_both: a_included = Void or a_excluded = Void
		do
			type := a_type
			generate_invariant_function (a_included, a_excluded, a_ancestor)
			generate_filtered_invariant_axiom (a_included, a_excluded, a_ancestor)
		end

	translate_invariant (a_type: E2B_CL_TYPE_A; a_filter: E2B_INVARIANT_FILTER; a_target: IV_EXPRESSION): LINKED_LIST [IV_ASSERT]
			-- Translate the invariant of `a_type` with target `a_target` into assert statements.
			-- If `a_target` is `Void`, then target is `Current`
			--
			-- If `a_filter` is not `Void`, only invariants matching `a_filter`
			-- are processed and returned
		local
			l_mapping: E2B_ENTITY_MAPPING
		do
			if attached a_type.base_class.invariant_feature as l_feat then
				l_feat.switch_byte_context (a_type, a_type)
			else
				switch_byte_context (a_type, a_type)
			end
			type := a_type
			if a_target = Void and a_filter = Void then
					-- Standard target: use cache
				if invariant_check_cache.has_key (type) then
					Result := invariant_check_cache [type]
				else
					create builtin_collector
					create l_mapping.make
					Result := collect_invariants (type.base_class, Void, l_mapping)
					invariant_check_cache.put (Result, type)
				end
			else
				create builtin_collector
				create l_mapping.make
				if a_target /= Void then
					l_mapping.set_current (a_target)
				end
				Result := collect_invariants (type.base_class, a_filter, l_mapping)
			end
			helper.unswitch_byte_context
		end

feature {NONE} -- Implementation

	translate_invariant_function
			-- Translate invariant of `type'.
		require
			a_type_exists: type /= Void
		do
			generate_invariant_function (Void, Void, type.base_class)
			generate_invariant_axiom ("user_inv", name_translator.boogie_function_for_invariant (type))
		end

	generate_inheritance_relations
			-- Generate axioms
			-- "TYPE <: PARENT1", "TYPE <: PARENT2", ..., and
			-- "forall t: Type :: {TYPE <: t} TYPE <: t <==> TYPE == t || PARENT1 <: t || PARENT2 <: t || ...".
		local
			l_parents: FIXED_LIST [E2B_CL_TYPE_A]
			l_parent: E2B_CL_TYPE_A
			l_type_value: IV_VALUE
			l_parent_value: IV_VALUE
			l_rhs: IV_EXPRESSION
			l_t: IV_ENTITY
			l_forall: IV_FORALL
		do
			create l_type_value.make (name_translator.boogie_name_for_type (type), types.type)
			create l_t.make ("t", types.type)
			l_rhs := factory.equal (l_t, l_type_value)
			l_parents := type.base_class.parents
			from
				l_parents.start
			until
				l_parents.after
			loop
				l_parent := l_parents.item.instantiated_in (type)
				translation_pool.add_parent_type (l_parent)
				create l_parent_value.make (name_translator.boogie_name_for_type (l_parent), types.type)
				l_rhs := factory.or_ (l_rhs, factory.sub_type (l_parent_value, l_t))
				boogie_universe.add_declaration (create {IV_AXIOM}.make (factory.sub_type (l_type_value, l_parent_value)))
				l_parents.forth
			end
			create l_forall.make (factory.equiv (factory.sub_type (l_type_value, l_t), l_rhs))
			l_forall.add_bound_variable (l_t)
			l_forall.add_trigger (factory.sub_type (l_type_value, l_t))
			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

	generate_model_axiom
			-- Generate an axiom listing all model queries of `type'.
		local
			l_type_var: IV_VAR_TYPE
			l_f, l_m: IV_ENTITY
			l_def: IV_EXPRESSION
			l_fcall: IV_FUNCTION_CALL
			l_forall: IV_FORALL
		do
			create l_type_var.make_fresh
			create l_f.make ("$f", types.field (l_type_var))
			l_def := factory.false_
			across type.base_class.flat_model_queries as l_query loop
				if l_query.written_in /= system.any_id then
					translation_pool.add_referenced_feature (l_query, type)
				end
				create l_m.make (
					l_query.boogie_name_for_attribute (type),
					types.field (types.for_class_type (type.base_class.class_type_in_context (l_query.type, l_query, type))))
				l_def := factory.or_clean (l_def, factory.equal (l_f, l_m))
			end
			l_fcall := factory.function_call ("IsModelField", << l_f, factory.type_value (type) >>, types.bool)
			create l_forall.make (factory.equiv (l_fcall, l_def))
			l_forall.add_type_variable (l_type_var.name)
			l_forall.add_bound_variable (l_f)
			l_forall.add_trigger (l_fcall)
			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

	generate_invariant_function (a_included, a_excluded: LIST [STRING]; a_ancestor: E2B_CLASS_C)
			-- Generate invariant function for `type';
			-- if `a_included /= Void', include only those clauses;
			-- if `a_excluded /= Void', exclude those clauses;
			-- restrict clauses to those inherited from `a_ancestor'.
		do
		end

	generate_tuple_invariant_clauses (a_mapping: E2B_ENTITY_MAPPING)
			-- Translate invariant clauses for `type' using `a_mapping', add default clauses;
			-- store result in `last_clauses'.
		require
			type_exists: type /= Void
		do
			create builtin_collector
			create last_clauses.make
			add_default_clause ("observers", translation_mapping.default_tags [1], Void, Void, a_mapping)
			add_default_clause ("subjects", translation_mapping.default_tags [2], Void, Void, a_mapping)
			add_default_clause ("owns", translation_mapping.default_tags [3], Void, Void, a_mapping)
		end

	add_default_clause (a_name, a_tag: READABLE_STRING_8; a_included, a_excluded: LIST [READABLE_STRING_8]; a_mapping: E2B_ENTITY_MAPPING)
			-- Add default definition for a built-in attrbute `a_name' with tag `a_tag'.
		do
		end

	empty_set_property (a_name: READABLE_STRING_8; a_mapping: E2B_ENTITY_MAPPING): IV_EXPRESSION
		do
			Result := factory.function_call (
				"Set#IsEmpty",
				<<factory.heap_access (a_mapping.heap, a_mapping.current_expression, a_name, types.set (types.ref))>>,
				types.bool)
		end

	processed_classes: ARRAYED_LIST [INTEGER]
			-- List of classes already seen during the latest call to `process_invariants'.

feature {NONE}

	collect_invariants (a_class: E2B_CLASS_C; a_filter: E2B_INVARIANT_FILTER; a_mapping: E2B_ENTITY_MAPPING): LINKED_LIST [IV_ASSERT]
			-- Process invariants of `a_class' which match and its ancestors, and return them.
		require
			a_class_exists: a_class /= Void
			a_mapping_exists: a_mapping /= Void
		do
			create last_clauses.make
			create last_safety_checks.make
			create processed_classes.make (5)

			processed_classes.extend (system.any_id)
			Result := collect_flat_invariants (a_class, a_filter, a_mapping)
		end


	collect_flat_invariants (a_class: E2B_CLASS_C; a_filter: E2B_INVARIANT_FILTER; a_mapping: E2B_ENTITY_MAPPING): LINKED_LIST [IV_ASSERT]
			-- Recursively process invariants of `a_class' and its ancestors.
		local
			l_classes: FIXED_LIST [E2B_CLASS_C]
		do
			create Result.make
			from
				l_classes := a_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				if not processed_classes.has (l_classes.item.class_id) then
					Result.append (collect_flat_invariants (l_classes.item, a_filter, a_mapping))
				end
				l_classes.forth
			end
			Result.append (collect_immediate_invariants (a_class, a_filter, a_mapping))
			processed_classes.extend (a_class.class_id)
		end

	collect_immediate_invariants (a_class: E2B_CLASS_C; a_filter: E2B_INVARIANT_FILTER; a_mapping: E2B_ENTITY_MAPPING): LINKED_LIST [IV_ASSERT]
			-- Process invariants written in `a_class'.
		require
			a_class_not_void: a_class /= Void
		local
			l_clause: IV_ASSERT
			l_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR
			l_type: E2B_CL_TYPE_A
		do
			create Result.make

			if
				attached a_class.invariant_feature as invariant_feature
					-- If class has no invariant, invariant_feature is Void.
					-- Skip this class

				and then inv_byte_server.has (a_class.class_id)
			then
				l_type := a_class.class_type_in_context (a_class.actual_type, invariant_feature, type)
				invariant_feature.switch_byte_context (l_type, l_type)
				across
					inv_byte_server.item (a_class.class_id).byte_list as l_assert
				loop
					if a_filter = Void or else a_filter.is_matching (l_assert) then
						create l_translator.make
						l_translator.set_context (invariant_feature, type)
							-- Entity mapping should be copied after setting the context
							-- because setting the context can also set a mapping for "Current".
						l_translator.copy_entity_mapping (a_mapping)
						l_translator.set_origin_class (a_class)
						l_translator.set_context_line_number (l_assert.line_number)
						l_translator.set_context_tag (l_assert.tag)
						l_translator.set_context_readable (factory.function_call ("user_inv_readable", << a_mapping.heap, a_mapping.current_expression >>, types.frame))
						l_translator.set_use_triggers (True)
						l_assert.process (l_translator)
						last_safety_checks.append (l_translator.side_effect)
						last_safety_checks.extend (create {IV_ASSERT}.make_assume (l_translator.last_expression))
						create l_clause.make (l_translator.last_expression)
						l_clause.node_info.set_type ("inv")
						l_clause.node_info.set_tag (l_assert.tag)
						l_clause.node_info.set_line (l_assert.line_number)
						l_clause.node_info.set_attribute ("cid", a_class.class_id.out)
						Result.extend (l_clause)
					end
					l_assert.process (builtin_collector)
				end
				helper.unswitch_byte_context
			end
		end

	generate_invariant_axiom (a_generic_function, a_special_function: STRING)
			-- Generate axioms that connect `a_generic_function' with `a_special_function'.
		local
			l_heap, l_current: IV_ENTITY
			l_generic_call, l_special_call: IV_FUNCTION_CALL
		do
			create l_heap.make ("heap", types.heap)
			create l_current.make ("current", types.ref)
			l_generic_call := factory.function_call (a_generic_function, << l_heap, l_current >>, types.bool)
			l_special_call := factory.function_call (a_special_function, << l_heap, l_current >>, types.bool)

			factory.add_dynamic_predicate_definition (
				factory.function_call (a_generic_function, << l_heap, l_current >>, types.bool),
				factory.function_call (a_special_function, << l_heap, l_current >>, types.bool),
				type, l_heap, l_current, <<>>)
		end

	generate_ghost_definition (a_expr: IV_EXPRESSION; a_attr: E2B_FEATURE_I): BOOLEAN
			-- If `a_expr' has the form `a_name = def', create a Boogie function that defines `a_name' for `type' as `def'.
			-- (Only accepting definitions of this form to avoid cycles).
		local
			l_fname: STRING
			l_current, l_heap, l_field: IV_ENTITY
			l_def: IV_EXPRESSION
			l_function: IV_FUNCTION
		do
			create l_current.make ("current", types.ref)
			create l_heap.make ("heap", types.heap)

			l_def := definition_of (a_expr, l_heap, l_current, a_attr)
			if attached l_def and not type.base_class.is_explicit (a_attr.feature_name) then
				l_field := a_attr.field_from_attribute (type)
				l_fname := name_translator.boogie_function_for_ghost_definition (type, l_field.name)
				l_function := boogie_universe.function_named (l_fname)
				if l_function = Void then
						-- There is no definition for this model query yet
					create l_function.make (l_fname, l_def.type)
					l_function.add_argument (l_heap.name, l_heap.type)
					l_function.add_argument (l_current.name, l_current.type)
					l_function.set_body (l_def)
					boogie_universe.add_declaration (l_function)
				else
						-- There is a definition already, but we have found a new one, lower in the hierarchy
						-- so it should take precedence
					l_function.set_body (l_def)
				end
				Result := True
			end
		end

	definition_of (a_expr: IV_EXPRESSION; a_heap, a_current: IV_ENTITY; a_attr: E2B_FEATURE_I): detachable IV_EXPRESSION
			-- If `a_expr' has the form `a_name = def' return `def', otherwise `Void'.
		local
			l_type: E2B_CL_TYPE_A
			l_field: IV_ENTITY
			l_eq: READABLE_STRING_8
		do
			l_type := type.base_class.class_type_in_context (a_attr.type, type.base_class.invariant_feature, type)
			l_field := a_attr.field_from_attribute (type)
			if l_type.base_class.is_logical then
				l_eq := (l_type.base_class.feature_named ("is_equal")).function_name_if_logical
				if
					attached {IV_FUNCTION_CALL} a_expr as fcall and then
					fcall.name.same_string (l_eq) and then
					fcall.arguments [1].same_expression (factory.heap_access (a_heap, a_current, l_field.name, types.field_content_type (l_field.type)))
				then
					Result := fcall.arguments [2]
				end
			elseif
				attached {IV_BINARY_OPERATION} a_expr as binop and then
				binop.operator.same_string ("==") and then
				binop.left.same_expression (factory.heap_access (a_heap, a_current, l_field.name, types.field_content_type (l_field.type)))
			then
				Result := binop.right
			end
		end

	generate_filtered_invariant_axiom (a_included, a_excluded: LIST [STRING]; a_ancestor: E2B_CLASS_C)
			-- Generate axiom (forall o: ref :: {partial_inv(h, o)} IsHeap(h) && h[o, allocated] && h[o, closed] ==> partial_inv(h, o))
		local
			l_h, l_o: IV_ENTITY
			l_fcall: IV_FUNCTION_CALL
			l_forall: IV_FORALL
		do
			create l_h.make ("h", types.heap)
			create l_o.make ("o", types.ref)
			l_fcall := factory.function_call (name_translator.boogie_function_for_filtered_invariant (type, a_included, a_excluded, a_ancestor),
					<<l_h, l_o>>, types.bool)
			create l_forall.make (factory.implies_ (
					factory.and_ (factory.function_call ("IsHeap", <<l_h>>, types.bool),
						factory.and_ (
							factory.function_call ("attached", <<l_h, l_o, factory.type_value (type)>>, types.bool),
							factory.heap_access (l_h, l_o, "closed", types.bool))),
					l_fcall))
			l_forall.add_bound_variable (l_h)
			l_forall.add_bound_variable (l_o)
			l_forall.add_trigger (l_fcall)
			boogie_universe.add_declaration (create {IV_AXIOM}.make (l_forall))
		end

	add_default_field_ids
			-- Add FieldId axioms for default attributes
		do
			boogie_universe.add_declaration (factory.field_id ("allocated", types.bool, type, -1))
		end

	translate_is_initialized_with_default
			-- Add axiom for `IsInitializedWithDefault` for this type.
		local
			type_var: IV_VAR_TYPE
			field: IV_ENTITY
			call: IV_FUNCTION_CALL
			forall: IV_FORALL
			definition: IV_EXPRESSION
			feat: E2B_FEATURE_I
		do
			create type_var.make_fresh
			create field.make ("$f", types.field (type_var))
			call := factory.function_call (
				"IsInitializedWithDefault",
				<< field, factory.type_value (type) >>,
				types.bool
			)
				-- The special field `allocated` is not initialized
			definition := factory.not_equal (
				field,
				create {IV_ENTITY}.make ("allocated", types.field (type_var))
			)
			across type.base_class.skeleton.area as attr_desc loop
				if attr_desc.type_i.is_initialization_required then
						-- `is_initialization_required` means that default value is not applied
						-- and the attribute must be initialized in the creation procedure
					feat := type.base_class.feature_of_feature_id (attr_desc.feature_id)
					translation_pool.add_referenced_feature (feat, type)
					definition := factory.and_clean (definition, factory.not_equal (
						field, create {IV_ENTITY}.make (
							feat.boogie_name_for_attribute (type),
							types.field (types.for_class_type (
								type.base_class.class_type_in_context (feat.type, feat, type))
							))
					))
				end
			end

			create forall.make (factory.equiv (call, definition))
			forall.add_type_variable (type_var.name)
			forall.add_bound_variable (field)
			forall.add_trigger (call)
			boogie_universe.add_declaration (create {IV_AXIOM}.make (forall))
		end

feature -- Invariant admissibility

	handle_class_validity_result (a_class: E2B_CLASS_C; a_boogie_result: E2B_BOOGIE_PROCEDURE_RESULT; a_result_generator: E2B_RESULT_GENERATOR)
			-- Handle Boogie result `a_boogie_result'.
		local
			l_success: E2B_SUCCESSFUL_VERIFICATION
			l_failure: E2B_FAILED_VERIFICATION
			l_error: E2B_DEFAULT_VERIFICATION_ERROR
		do
			if a_result_generator.has_validity_error (Void, a_class) then
				-- Ignore results of classes with a validity error

			elseif a_boogie_result.is_successful then
				create l_success
				l_success.set_class (a_class)
				l_success.set_time (a_boogie_result.time)
				l_success.set_verification_context ("invariant admissibility")
				a_result_generator.last_result.add_result (l_success)

			elseif a_boogie_result.is_inconclusive then
					-- TODO

			elseif a_boogie_result.is_error then
				create l_failure.make
				l_failure.set_class (a_class)
				l_failure.set_verification_context ("invariant admissibility")
				across a_boogie_result.errors as i loop
					check i.is_assert_error end
					create l_error.make (l_failure)
					l_error.set_boogie_error (i)
					if i.attributes["type"] ~ "A2" then
						l_error.set_message ({STRING_32} "Some subjects might not have Current in their observers set.")
						l_failure.errors.extend (l_error)
					elseif i.attributes["type"] ~ "A3" then
						l_error.set_message ({STRING_32} "The invariant might be invalidated by a subject update that conforms to its guard.")
						l_failure.errors.extend (l_error)
					else
						a_result_generator.process_individual_error (i, l_failure)
					end
				end
				a_result_generator.last_result.add_result (l_failure)
			end
		end

	invariant_check_cache: HASH_TABLE [LINKED_LIST [IV_ASSERT], E2B_CL_TYPE_A]
			-- Cache of inline invariant checks per type.
		once
			create Result.make (5)
		end

note
	date: "$Date$"
	revision: "$Revision$"
	copyright:
		"Copyright (c) 2012-2014 ETH Zurich",
		"Copyright (c) 2018-2019 Politecnico di Milano",
		"Copyright (c) 2021-2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Nadia Polikarpova", "Alexander Kogtenkov"
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
