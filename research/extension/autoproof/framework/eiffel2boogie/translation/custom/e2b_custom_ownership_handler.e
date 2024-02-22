class
	E2B_CUSTOM_OWNERSHIP_HANDLER

inherit

	E2B_CUSTOM_CALL_HANDLER

	SHARED_WORKBENCH

	SHARED_SERVER

feature -- Status report

	is_handling_call (a_target_type: E2B_TYPE_A; a_feature: E2B_FEATURE_I): BOOLEAN
			-- <Precursor>
		do
			Result := (translation_mapping.builtin_any_functions.has (a_feature.feature_name) or
				translation_mapping.builtin_any_procedures.has (a_feature.feature_name) or
				translation_mapping.ghost_access.has (a_feature.feature_name) or
				translation_mapping.ghost_setter.has (a_feature.feature_name))
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: E2B_FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_call: IV_PROCEDURE_CALL
			l_type: IV_TYPE
			l_trig: IV_FUNCTION_CALL
			l_old_side_effect: LINKED_LIST [IV_STATEMENT]
		do
			l_name := a_feature.feature_name
			if l_name ~ "use_definition" then
				l_old_side_effect := a_translator.side_effect
				a_translator.clear_side_effect
				a_translator.process_parameters (a_parameters)
				a_translator.restore_side_effect (l_old_side_effect)
				check a_translator.last_parameters.count = 1 end
				if attached {IV_FUNCTION_CALL} a_translator.last_parameters.first as l_fcall then
					create l_trig.make (name_translator.boogie_function_trigger (l_fcall.name), types.bool)
					l_trig.arguments.append (l_fcall.arguments)
					a_translator.side_effect.extend (create {IV_ASSERT}.make_assume (l_trig))
				end
			elseif l_name ~ "transitive_owns" then
				a_translator.process_builtin_function_call (a_feature, a_parameters, "trans_owns")
			elseif l_name ~ "ownership_domain" then
				a_translator.process_builtin_function_call (a_feature, a_parameters, "domain")
			elseif translation_mapping.builtin_any_functions.has (l_name) then
				a_translator.process_builtin_function_call (a_feature, a_parameters, l_name)
			elseif l_name ~ "unwrap_no_inv" then
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "unwrap")
			elseif translation_mapping.builtin_any_procedures.has (l_name) then
				pre_builtin_call (a_translator, a_feature)
				a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
				post_builtin_call (a_translator, a_feature)
			elseif translation_mapping.ghost_access.has (l_name) then
				if l_name ~ "closed" then
					l_type := types.bool
					a_translator.set_last_expression (factory.function_call ("is_closed", << a_translator.entity_mapping.heap, a_translator.current_target >>, l_type))
				else
					l_type := translation_mapping.ghost_access_type (l_name)
					a_translator.set_last_expression (factory.heap_access (a_translator.entity_mapping.heap, a_translator.current_target, l_name, l_type))
				end
			elseif translation_mapping.ghost_setter.has (l_name) then
				l_name := l_name.substring (5, l_name.count)
				a_translator.process_builtin_routine_call (a_feature, a_parameters, "xyz")
				if attached {IV_PROCEDURE_CALL} a_translator.side_effect.last as c then
					a_translator.side_effect.finish
					a_translator.side_effect.remove	-- last side effect is actual call, here to non-existing "xyz"
					a_translator.set_last_expression (Void)
					l_call := factory.procedure_call ("update_heap", <<
						a_translator.current_target,
						factory.entity (l_name, types.field ((create {E2B_SPECIAL_MAPPING}.make).ghost_access_type (l_name))),
						c.arguments.i_th (2)>>)
					l_call.node_info.set_line (a_translator.context_line_number)
					a_translator.side_effect.extend (l_call)
				end
			else
				check false end
			end
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: E2B_FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- <Precursor>
		local
			l_name: STRING
			l_type: IV_TYPE
			l_tag_filters: LIST [STRING]
			l_attr: E2B_FEATURE_I
			l_partial_inv_class: E2B_CLASS_C
		do
			l_name := a_feature.feature_name
			if translation_mapping.builtin_any_functions.has (l_name) then
				if l_name ~ "inv_without" then
					l_tag_filters := extract_tags (a_parameters)
						-- Determine the class whose invariant is taken as reference:
						-- if target is Current, then it is the origin class of the contract clause,
						-- otherwise, it is the type of the target
					if a_translator.current_target.same_expression (a_translator.entity_mapping.current_expression) then
						l_partial_inv_class := a_translator.origin_class
					else
						l_partial_inv_class := a_translator.current_target_type.base_class
					end
					check_valid_class_inv_tags (l_partial_inv_class, a_translator.context_feature, a_translator.context_line_number, l_tag_filters)
					translation_pool.add_filtered_invariant_function (a_translator.current_target_type, Void, l_tag_filters, l_partial_inv_class)
					a_translator.set_last_expression(factory.function_call (
							name_translator.boogie_function_for_filtered_invariant (a_translator.current_target_type, Void, l_tag_filters, l_partial_inv_class),
							<< a_translator.entity_mapping.heap, a_translator.current_target >>, types.bool))
				elseif l_name ~ "inv_only" then
					l_tag_filters := extract_tags (a_parameters)
					if a_translator.current_target.same_expression (a_translator.entity_mapping.current_expression) then
						l_partial_inv_class := a_translator.origin_class
					else
						l_partial_inv_class := a_translator.current_target_type.base_class
					end
					check_valid_class_inv_tags (l_partial_inv_class, a_translator.context_feature, a_translator.context_line_number, l_tag_filters)
					translation_pool.add_filtered_invariant_function (a_translator.current_target_type, l_tag_filters, Void, l_partial_inv_class)
					a_translator.set_last_expression(factory.function_call (
						name_translator.boogie_function_for_filtered_invariant (a_translator.current_target_type, l_tag_filters, Void, l_partial_inv_class),
						<< a_translator.entity_mapping.heap, a_translator.current_target >>, types.bool))
				elseif l_name ~ "inv" then
						a_translator.process_builtin_routine_call (a_feature, a_parameters, "user_inv")
				elseif l_name ~ "is_field_writable" then
					if attached {STRING_B} a_parameters.first.expression as l_string then
						-- ToDo: can origin class be different?
						l_attr := a_translator.current_target_type.base_class.attribute_from_string (l_string.value, a_translator.current_target_type, a_translator.context_feature, a_translator.context_line_number)
						if attached l_attr then
							a_translator.set_last_expression (factory.frame_access (
								a_translator.context_writable,
								a_translator.current_target,
								l_attr.field_from_attribute (a_translator.current_target_type)))
						end
					else
						e2b_error.add_semantic_error (a_translator.context_feature, messages.first_argument_string, a_translator.context_line_number)
					end
				elseif l_name ~ "is_fully_writable" then
					a_translator.set_last_expression (factory.function_call (
						"has_whole_object",
						<< a_translator.context_writable, a_translator.current_target>>,
						types.bool))
				elseif l_name ~ "is_field_readable" then
					if attached a_translator.context_readable then
						if attached {STRING_B} a_parameters.first.expression as l_string then
							l_attr := a_translator.current_target_type.base_class.attribute_from_string (l_string.value, a_translator.current_target_type, a_translator.context_feature, a_translator.context_line_number)
							if attached l_attr then
								a_translator.set_last_expression (factory.frame_access (
									a_translator.context_readable,
									a_translator.current_target,
									l_attr.field_from_attribute (a_translator.current_target_type)))
							end
						else
							e2b_error.add_semantic_error (a_translator.context_feature, messages.first_argument_string, a_translator.context_line_number)
						end
					else
						e2b_error.add_semantic_warning (a_translator.context_feature, messages.invalid_context_for_read_predicate, a_translator.context_line_number)
						a_translator.set_last_expression (factory.true_)
					end
				elseif l_name ~ "is_fully_readable" then
					if attached a_translator.context_readable then
						a_translator.set_last_expression (factory.function_call (
							"has_whole_object",
							<< a_translator.context_readable, a_translator.current_target>>,
							types.bool))
					else
						e2b_error.add_semantic_warning (a_translator.context_feature, messages.invalid_context_for_read_predicate, a_translator.context_line_number)
						a_translator.set_last_expression (factory.true_)
					end
				elseif l_name ~ "transitive_owns" then
					a_translator.process_builtin_routine_call (a_feature, a_parameters, "trans_owns")
				elseif l_name ~ "ownership_domain" then
					a_translator.process_builtin_routine_call (a_feature, a_parameters, "domain")
				elseif l_name ~ "universe" then
					a_translator.set_last_expression (factory.entity ("universe", types.set (types.ref)))
				elseif l_name ~ "is_fresh" then
					a_translator.set_last_expression (factory.not_ (factory.heap_access (
						factory.old_ (factory.global_heap),
						a_translator.current_target, "allocated", types.bool)))
				else
					a_translator.process_builtin_routine_call (a_feature, a_parameters, l_name)
				end
			elseif translation_mapping.ghost_access.has (l_name) then
				if l_name ~ "closed" then
					l_type := types.bool
					a_translator.set_last_expression (factory.function_call ("is_closed", << a_translator.entity_mapping.heap, a_translator.current_target >>, l_type))
				else
					l_type := translation_mapping.ghost_access_type (l_name)
					a_translator.set_last_expression (factory.heap_access (a_translator.entity_mapping.heap, a_translator.current_target, l_name, l_type))
				end
			else
					-- cannot happen
				check False end
			end
		end

	extract_tags (a_parameters: BYTE_LIST [PARAMETER_B]): LIST [STRING]
		do
			check a_parameters.count = 1 end
			create {LINKED_LIST [STRING]} Result.make
			Result.compare_objects
			if attached {STRING_B} a_parameters.first.expression as l_string then
				Result.extend (l_string.value)
			elseif attached {TUPLE_CONST_B} a_parameters.first.expression as l_tuple then
				across l_tuple.expressions as i loop
					if attached {STRING_B} i as l_string then
						Result.extend (l_string.value)
					else
						check False end
					end
				end
			else
				check False end
			end
		end

	check_valid_class_inv_tags (a_class: E2B_CLASS_C; a_context_feature: E2B_FEATURE_I; a_line_number: INTEGER; a_tags: LIST [READABLE_STRING_8])
			-- Check if `a_tags' only lists valid class invariant of `a_class'.
			-- Otherwise report error in feature `a_context_feature'.
		local
			l_tags_copy: LINKED_LIST [READABLE_STRING_8]
			l_string: STRING_32
		do
			create l_tags_copy.make
			l_tags_copy.append (a_tags)
			l_tags_copy.compare_objects
				-- Remove default tags
			across translation_mapping.default_tags as t loop
				l_tags_copy.prune_all (t)
			end
				-- Remove user-defined tags
			check_flat_inv_tags (a_class, l_tags_copy)
			if not l_tags_copy.is_empty then
				l_string := {STRING_32} ""
				across l_tags_copy as i loop
					l_string.append ({UTF_CONVERTER}.utf_8_string_8_to_string_32 (i))
					l_string.append ({STRING_32} ", ")
				end
				l_string.remove_tail (2)
				e2b_error.add_semantic_error (a_context_feature, messages.invalid_tag (l_string, a_class.name_in_upper), a_line_number)
			end
		end

	check_flat_inv_tags (a_class: E2B_CLASS_C; a_tags: LIST [READABLE_STRING_8])
			-- Remove from `a_tags' all class invariant tags present in `a_class' and its ancestors.
		local
			l_classes: FIXED_LIST [E2B_CLASS_C]
		do
			if inv_byte_server.has (a_class.class_id) then
				across
					inv_byte_server.item (a_class.class_id).byte_list as node
				loop
					if attached {ASSERT_B} node as a then
						a_tags.prune_all (a.tag)
					end
				end
			end
			from
				l_classes := a_class.parents_classes
				l_classes.start
			until
				l_classes.after
			loop
				if l_classes.item.class_id /= system.any_id then
					check_flat_inv_tags (l_classes.item, a_tags)
				end
				l_classes.forth
			end
		end

	pre_builtin_call (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: E2B_FEATURE_I)
			-- Insert code before calling a built-in procedure `a_feature_name'.
		do
		end

	post_builtin_call (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: E2B_FEATURE_I)
			-- Insert code after calling a built-in procedure `a_feature_name'.
		do
		end

	use_static_invariant (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR): BOOLEAN
			-- Should the static definition of the invariant be used for the current target of `a_translator'?
		do
				-- Yes if the current target is "Current" and the context feature is not marked as nonvariant,
				-- or the type of the target is exact.
			Result := (a_translator.current_target.same_expression (a_translator.entity_mapping.current_expression) and
				not a_translator.context_feature.is_nonvariant ) or
				a_translator.current_target_type.is_exact (a_translator.current_target_type, a_translator.context_feature)
		end

	set_implicit_ghost (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_attr: E2B_FEATURE_I)
			-- If the definition of `a_attr' in `current_target_type' is statically known,
			-- generate a guarded update and store it in the side effect of `a_translator'.
		local
			l_function: IV_FUNCTION
			l_field: IV_ENTITY
			l_pcall: IV_PROCEDURE_CALL
			l_fcall: IV_FUNCTION_CALL
			l_if: IV_CONDITIONAL
		do
				-- Get definition of `a_field_name' for `current_target_type';
				-- if it exists, generate a guarded assignment.			
			l_field := a_attr.field_from_attribute (a_translator.current_target_type)
			l_function := boogie_universe.function_named (
				name_translator.boogie_function_for_ghost_definition (a_translator.current_target_type, l_field.name))
			if attached l_function then
				create l_pcall.make ("update_heap")
				l_pcall.add_argument (a_translator.current_target)
				l_pcall.add_argument (l_field)
				l_pcall.add_argument (factory.function_call (l_function.name,
					<< a_translator.entity_mapping.heap, a_translator.current_target >>,
					types.field_content_type (l_field.type)))
				l_pcall.node_info.set_attribute ("default", a_attr.feature_name)
				l_pcall.node_info.set_line (a_translator.context_line_number)

					-- Create a condition that l_field is in the modify clause of the current function
					-- (modify clause is used instead of writable, since it is not possible to prove that something is not writable)
				create l_fcall.make (name_translator.boogie_function_for_write_frame (a_translator.context_feature, a_translator.context_type), types.frame)
				l_fcall.add_argument (factory.global_heap)
				across a_translator.context_implementation.procedure.arguments as i loop
					l_fcall.add_argument (i.entity)
				end

				create l_if.make_if_then (factory.frame_access (l_fcall, a_translator.current_target, l_field),
					factory.singleton_block (l_pcall))
				l_if.node_info.set_attribute ("status", "ghost")
				a_translator.side_effect.extend (l_if)
			end
		end

note
	date: "$Date$"
	revision: "$Revision$"
	copyright:
		"Copyright (c) 2012-2014 ETH Zurich",
		"Copyright (c) 2018-2019 Politecnico di Milano",
		"Copyright (c) 2022 Schaffhausen Institute of Technology"
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
