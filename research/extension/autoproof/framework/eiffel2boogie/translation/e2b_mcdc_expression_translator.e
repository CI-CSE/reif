class
	E2B_MCDC_EXPRESSION_TRANSLATOR

inherit

	E2B_BODY_EXPRESSION_TRANSLATOR
		redefine
				-- make,
			process_instr_call_b,
			process_argument_b,
			process_attribute_b,
			process_local_b,
			process_result_b,
				-- process_bin_and_b,
				-- process_bin_and_then_b,
			process_bin_eq_b,
				-- process_bin_free_b,
			process_bin_ge_b,
			process_bin_gt_b,
			process_bin_implies_b,
			process_bin_le_b,
			process_bin_lt_b,
				-- process_bin_minus_b,
			process_bin_ne_b,
				-- process_bin_mod_b,
			process_bin_or_b,
			process_bin_or_else_b,
				-- process_bin_plus_b,
				-- process_bin_power_b,
				-- process_bin_slash_b,
				-- process_bin_star_b,
			process_bin_tilde_b,
			process_bin_xor_b,
			process_bool_const_b,
				-- process_char_const_b,
				-- process_char_val_b,
				-- process_constant_b,
				-- process_creation_expr_b,
				-- process_current_b,
				-- process_external_b,
				-- process_feature_b,
				-- process_if_expression_b,
				-- process_int64_val_b,
				-- process_int_val_b,
				-- process_integer_constant,
				-- process_local_b,
				-- process_loop_expr_b,
				-- process_nat64_val_b,
				-- process_nat_val_b,
				-- process_nested_b,
				-- process_null_conversion_b,
			process_object_test_b,
			process_object_test_local_b,
				-- process_parameter_b,
				-- process_paran_b,
				-- process_result_b,
				-- process_real_const_b,
				-- process_routine_creation_b,
				-- process_string_b,
				-- process_tuple_access_b,
				-- process_tuple_const_b,
				-- process_type_expr_b,
				-- process_un_free_b,
				-- process_un_minus_b,
			process_access_expr_b,
			process_un_not_b
			-- process_un_old_b,
			-- process_un_plus_b,
			-- process_void_b
		end

	E2B_SHARED_CONTEXT
		export {NONE} all end

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	SHARED_BYTE_CONTEXT

	COMPILER_EXPORTER

create
	make, make_from_test

feature {NONE} -- Initialization

	make_from_test (a_test: like mcdc_test)
			-- Initialize translator.
		do
			mcdc_test := a_test
			reset
		end

feature -- Access

	mcdc_test: ARRAYED_LIST [BOOLEAN]
			-- A sequence of boolean values for the conditions in the processed expression

	current_condition_index: INTEGER
			-- Index of the current processed condition

--	last_node: E2B_MCDC_NODE
--			-- Last generated mcdc node

--	leaf_nodes: ARRAYED_LIST [E2B_MCDC_NODE]
--			-- A list of leaf nodes; each leaf node represent a condition

--	entity_mapping: E2B_ENTITY_MAPPING
--			-- Entity mapping used for translation.

--	last_expression: IV_EXPRESSION
--			-- Last generated expression.

--	side_effect: LINKED_LIST [IV_STATEMENT]
--			-- List of side effect statements.

--	context_feature: FEATURE_I
--			-- Context of expression.

--	context_type: CL_TYPE_A
--			-- Context of expression.

--	context_line_number: INTEGER
--			-- (approximate) line number of expression.

--	context_tag: detachable STRING
--			-- Context tag of expression (if any).

--	current_target: IV_EXPRESSION
--			-- Current target.

--	current_target_type: CL_TYPE_A
--			-- Type of current target.

--	locals_map: HASH_TABLE [IV_EXPRESSION, INTEGER]
--			-- Mapping of object test locals to entities.

--	across_handler_map: HASH_TABLE [E2B_ACROSS_HANDLER, INTEGER]
--			-- Mapping of object test locals from across loops to across handlers.

--	context_readable: IV_EXPRESSION
--			-- Readable frame of the enclosing context if defined, otherwise Void.

--	use_triggers: BOOLEAN
--			-- Should triggers be added to generated quntifiers?

--	use_uninterpreted_context_function: BOOLEAN
--			-- Translate function calls to `context_feature' with its uninterpreted version.

feature -- Convenience

--	class_type_in_current_context (a_type: TYPE_A): CL_TYPE_A
--			-- Class type that correspond to `a_type' in the context of `context_type' and possibly `context_feature'.
--		require
--			a_type_attached: attached a_type
--			context_type_attached: attached context_type
--			context_feature_attached: attached context_feature
--		do
--			Result := helper.class_type_in_context (a_type, context_feature.written_class, context_feature, context_type)
--		end

--	feature_class_type (a_feature: FEATURE_I): CL_TYPE_A
--			-- Type of `a_feature' in the context of `current_target_type'
--		require
--			a_feature_attached: attached a_feature
--			current_target_type_attached: attached current_target_type
--		do
--			Result := helper.class_type_in_context (a_feature.type, context_type.base_class, a_feature, context_type)
--		end

--	expression_class_type (a_node: EXPR_B): CL_TYPE_A
--			-- Type of `a_expr' in current context (takes redefinition into account).
--		require
--			a_node_attched: attached a_node
--			current_target_type_attached: attached current_target_type
--		do
--			if attached {EXTERNAL_B} a_node as ext and then ext.is_static_call then
--				Result := feature_class_type (helper.feature_for_call_access (ext, ext.static_class_type))
--			elseif attached {CALL_ACCESS_B} a_node as ca then
--				Result := feature_class_type (helper.feature_for_call_access (ca, current_target_type))
--			elseif attached {RESULT_B} a_node as res then
--				check attached context_feature and then context_feature.has_return_value end
--				Result := feature_class_type (context_feature)
--			else
--				Result := class_type_in_current_context (a_node.type)
--			end
--		end

--feature -- Element change

--	set_current_target (a_expression: IV_EXPRESSION)
--			-- Set `current_target' to `a_expression'.
--		do
--			current_target := a_expression
--		end

--	set_current_target_type (a_type: CL_TYPE_A)
--			-- Set `current_target_type' to `a_type'.
--		do
--			current_target_type := a_type
--		end

--	set_last_expression (a_expression: IV_EXPRESSION)
--			-- Set `last_expression' to `a_expression'.
--		do
--			last_expression := a_expression
--		end

--	set_context_line_number (a_line: INTEGER)
--			-- Set (approximate) line number of expression.
--		do
--			context_line_number := a_line
--		end

--	set_context_tag (a_tag: STRING)
--			-- Set context tag.
--		do
--			context_tag := a_tag
--		end

--feature -- Basic operations

--	set_context (a_feature: FEATURE_I; a_type: CL_TYPE_A)
--			-- Set context of expression to `a_feature' in type `a_type'.
--		require
--			a_feature_attached: attached a_feature
--			a_type_attached: attached a_type
--		do
--			context_feature := a_feature
--			context_type := a_type
--			current_target_type := a_type
--			if
--				attached {IV_ENTITY} entity_mapping.current_expression as e and then
--				attached types.for_class_type (a_type) as t and then
--				e.type /~ t
--			then
--					-- A fix for a target of a mapped MML type.
--				entity_mapping.set_current (create {IV_ENTITY}.make (e.name, t))
--			end
--			current_target := entity_mapping.current_expression
--			if a_feature /= Void and then a_feature.has_return_value then
--				entity_mapping.set_default_result (feature_class_type (a_feature))
--			end
--		end

--	copy_entity_mapping (a_entity_mapping: E2B_ENTITY_MAPPING)
--			-- Set `entity_mapping' to a copy of `a_entity_mapping'.
--		do
--			create entity_mapping.make_copy (a_entity_mapping)
--			current_target := entity_mapping.current_expression
--		end

--	reset
--			-- Reset expression translator.
--		do
--			last_node := Void
--			last_expression := Void
--			context_feature := Void
--			context_type := Void
--			current_target := Void
--			current_target_type := Void
--				-- local_writable := Void
--			context_readable := Void
--				-- last_set_content_type := Void
--			create entity_mapping.make
--			create locals_map.make (10)
--			create across_handler_map.make (10)
--			create leaf_nodes.make (0)

--				-- create safety_check_condition.make
--				-- safety_check_condition.extend (factory.true_)
--				-- create parameters_stack.make
--			use_triggers := False
--		end

feature -- Implementation

--	process_binary_operator (a_operator: STRING; a_node: BINARY_B)
--			-- Process non-leaf nodes with binary operator
----		local
----			l_left, l_right: E2B_MCDC_NODE
--		do
----			safe_process (a_node.left)
----			l_left := last_node

----			safe_process (a_node.right)
----			l_right := last_node

----			last_node := create {E2B_MCDC_NODE}.make (a_operator, l_left, l_right)

----			l_left.set_parent (last_node)
----			l_left.set_sibling (l_right)
----			l_right.set_parent (last_node)
----			l_right.set_sibling (l_left)
--		end

	process_leaf_node (a_operator: STRING; a_node: EXPR_B)
			-- Process leaf nodes that represent individual conditions
		do
				-- last_node := create {E2B_MCDC_NODE}.make (a_operator, Void, Void)
				-- leaf_nodes.extend (last_node)
				-- last_node.set_parent (a_parent: E2B_MCDC_NODE)
		end

	process_leaf_condition
		do
			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_leaf_condition%N")
			current_condition_index := current_condition_index + 1
				-- negate the condition if its expected value is False
			print ("mcdc value: " + mcdc_test [current_condition_index].out + "%N")
			if not mcdc_test [current_condition_index] then
				last_expression := factory.not_ (last_expression)
			end
		end

feature -- Visitors

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- <Precursor>
		do
			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_instr_call_b%N")
			Precursor (a_node)
			if a_node.call.type.is_boolean then
				process_leaf_condition
			end
		end

	process_argument_b (a_node: ARGUMENT_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_argument_b%N")
			Precursor (a_node)
			if a_node.type.is_boolean then
				process_leaf_condition
			end
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_attribute_b%N")
			Precursor (a_node)
			if a_node.type.is_boolean then
				process_leaf_condition
			end
		end

	process_local_b (a_node: LOCAL_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_local_b%N")
			Precursor (a_node)
			if a_node.type.is_boolean then
				process_leaf_condition
			end
		end

	process_result_b (a_node: RESULT_B)
			-- <Precursor>
		do
			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_result_b%N")
			Precursor (a_node)
			if a_node.type.is_boolean then
				process_leaf_condition
			end
		end

--	process_bin_and_b (a_node: BIN_AND_B)
--			-- <Precursor>
--		do
--			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_and_b%N")
--			process_binary_operator ("&&", a_node)
--		end

--	process_bin_and_then_b (a_node: B_AND_THEN_B)
--			-- <Precursor>
--		do
--				-- TODO: include the shortcut semantics; for the moment, use the same semantics as ordinary "and"
--			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_and_then_b%N")
--			process_binary_operator ("&&", a_node)
--		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_implies_b%N")
				-- process_binary_operator ("==>", a_node)
				-- process_binary_operator ("&&", a_node)
			process_binary (a_node, "&&")
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_eq_b%N")
				-- Precursor (a_node)
			if not a_node.left.type.is_boolean then
					-- equality checking for types other than boolean is mapped to a leaf node
				Precursor (a_node)
				process_leaf_condition
			else
				process_binary (a_node, "&&")
					-- process_binary_operator ("&&", a_node)
			end
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_ne_b%N")
			if not a_node.left.type.is_boolean then
				Precursor (a_node)
				process_leaf_condition
			else
				process_binary (a_node, "&&")
			end
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_or_b%N")
				-- process_binary_operator ("&&", a_node)
			process_binary (a_node, "&&")
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- <Precursor>
			-- local
			--	l_left, l_right: E2B_MCDC_NODE
		do
				-- TODO: include the shortcut semantics; for the moment, use the same semantics as ordinary "or"
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_or_else_b%N")
				-- process_binary_operator ("&&", a_node)
			process_binary (a_node, "&&")
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- <Precursor>
		do
			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_xor_b%N")
				-- process_binary_operator ("&&", a_node)
			process_binary (a_node, "&&")
		end

	process_bin_tilde_b (a_node: BIN_TILDE_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_tilde_b%N")

			if not a_node.left.type.is_boolean then
				Precursor (a_node)
				process_leaf_condition
			else
					-- process_binary_operator ("&&", a_node)
				process_binary (a_node, "&&")
			end
		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_ge_b%N")
				-- process_leaf_node (">=", a_node)
			Precursor (a_node)
			process_leaf_condition
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_gt_b%N")
				-- process_leaf_node (">", a_node)
			Precursor (a_node)
			process_leaf_condition
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_le_b%N")
				-- process_leaf_node ("<=", a_node)
			Precursor (a_node)
			process_leaf_condition
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bin_lt_b%N")
			Precursor (a_node)
			process_leaf_condition
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_bool_const_b%N")
				-- process_leaf_node ("", a_node)
			Precursor (a_node)
			process_leaf_condition
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_object_test_b%N")
				-- process_leaf_node ("", a_node)
			Precursor (a_node)
			process_leaf_condition
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- <Precursor>
		do
				-- print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_object_test_local_b%N")
			Precursor (a_node)
			process_leaf_condition
		end

	process_access_expr_b (a_node: ACCESS_EXPR_B)
			-- <Precursor>
		do
			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_access_expr_b%N")
			Precursor (a_node)
			print ("a_node.type.name: " + a_node.type.name + "%N")
--			if a_node.type.name.has_substring ("BOOLEAN") then
--				process_leaf_condition
--			end
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- <Precursor>
			-- local
			-- l_left: E2B_MCDC_NODE
		do
			print ("E2B_MCDC_EXPRESSION_TRANSLATOR.process_un_not_b%N")
			Precursor (a_node)
				-- safe_process (a_node.expr)
				-- last_expression := factory.not_ (last_expression)
--			l_left := last_node

--			last_node := create {E2B_MCDC_NODE}.make ("!", l_left, Void)
--			l_left.set_parent (last_node)
		end

note
	date: "$Date: 2022-01-19 03:46:44 +0800 (Wed, 19 Jan 2022) $"
	revision: "$Revision: 106120 $"
	copyright:
		"Copyright (c) 2012-2015 ETH Zurich",
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
