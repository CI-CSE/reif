class
	E2B_MCDC_NODE_GENERATOR

inherit

	E2B_VISITOR
		redefine
			process_argument_b,
			process_attribute_b,
			process_local_b,
			process_result_b,
			process_bin_and_b,
			process_bin_and_then_b,
			process_bin_eq_b,
			process_bin_ge_b,
			process_bin_gt_b,
			process_bin_implies_b,
			process_bin_le_b,
			process_bin_lt_b,
			process_bin_ne_b,
			process_bin_or_b,
			process_bin_or_else_b,
			process_bin_tilde_b,
			process_bin_xor_b,
			process_bool_const_b,
			process_object_test_b,
			process_object_test_local_b,
			process_tuple_access_b,
			process_instr_call_b,
			process_access_expr_b,
			process_un_not_b
		end

	E2B_SHARED_CONTEXT
		export {NONE} all end

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	SHARED_BYTE_CONTEXT

	COMPILER_EXPORTER

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize translator.
		do
			reset
		end

feature -- Access

	last_node: E2B_MCDC_NODE
			-- Last generated mcdc node

	leaf_nodes: ARRAYED_LIST [E2B_MCDC_NODE]
			-- A list of leaf nodes; each leaf node represent a condition

	entity_mapping: E2B_ENTITY_MAPPING
			-- Entity mapping used for translation.

	last_expression: IV_EXPRESSION
			-- Last generated expression.

	side_effect: LINKED_LIST [IV_STATEMENT]
			-- List of side effect statements.

	context_feature: FEATURE_I
			-- Context of expression.

	context_type: CL_TYPE_A
			-- Context of expression.

	context_line_number: INTEGER
			-- (approximate) line number of expression.

	context_tag: detachable STRING
			-- Context tag of expression (if any).

	current_target: IV_EXPRESSION
			-- Current target.

	current_target_type: CL_TYPE_A
			-- Type of current target.

	locals_map: HASH_TABLE [IV_EXPRESSION, INTEGER]
			-- Mapping of object test locals to entities.

	across_handler_map: HASH_TABLE [E2B_ACROSS_HANDLER, INTEGER]
			-- Mapping of object test locals from across loops to across handlers.

	context_readable: IV_EXPRESSION
			-- Readable frame of the enclosing context if defined, otherwise Void.

	use_triggers: BOOLEAN
			-- Should triggers be added to generated quntifiers?

	use_uninterpreted_context_function: BOOLEAN
			-- Translate function calls to `context_feature' with its uninterpreted version.

feature -- Convenience

	reset
			-- Reset expression translator.
		do
			last_node := Void
			last_expression := Void
			context_feature := Void
			context_type := Void
			current_target := Void
			current_target_type := Void
			context_readable := Void
			create entity_mapping.make
			create locals_map.make (10)
			create across_handler_map.make (10)
			create leaf_nodes.make (0)
			use_triggers := False
		end

feature -- Implementation

	process_binary_operator (a_operator: STRING; a_node: BINARY_B)
			-- Process non-leaf nodes with binary operator
		local
			l_left, l_right: E2B_MCDC_NODE
		do
			safe_process (a_node.left)
			l_left := last_node

			safe_process (a_node.right)
			l_right := last_node

			last_node := create {E2B_MCDC_NODE}.make (a_operator, l_left, l_right)

			l_left.set_parent (last_node)
			l_left.set_sibling (l_right)
			l_right.set_parent (last_node)
			l_right.set_sibling (l_left)
		end

	process_leaf_node (a_operator: STRING; a_node: EXPR_B)
			-- Process leaf nodes that represent individual conditions
		do
			last_node := create {E2B_MCDC_NODE}.make (a_operator, Void, Void)
			leaf_nodes.extend (last_node)
		end

feature -- Visitors

	process_argument_b (a_node: ARGUMENT_B)
			-- <Precursor>
		do
			if a_node.type.is_boolean then
				process_leaf_node ("", a_node)
			end
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- <Precursor>
		do
			if a_node.type.is_boolean then
				process_leaf_node ("", a_node)
			else
				check False end
			end
		end

	process_local_b (a_node: LOCAL_B)
			-- <Precursor>
		do
			if a_node.type.is_boolean then
				process_leaf_node ("", a_node)
			end
		end

	process_result_b (a_node: RESULT_B)
			-- Process `a_node'.
		do
			if a_node.type.is_boolean then
				process_leaf_node ("", a_node)
			end
		end

	process_bin_and_b (a_node: BIN_AND_B)
			-- <Precursor>
		do
			process_binary_operator ("&&", a_node)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
			-- <Precursor>
		do
				-- TODO: include the shortcut semantics; for the moment, use the same semantics as ordinary "and"
			process_binary_operator ("&&", a_node)
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- <Precursor>
		do
			process_binary_operator ("==>", a_node)
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- <Precursor>
		do
			if not a_node.left.type.is_boolean then
				process_leaf_node ("==", a_node)
			else
				process_binary_operator ("==", a_node)
			end
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- <Precursor>
		do
			if not a_node.left.type.is_boolean then
				process_leaf_node ("!=", a_node)
			else
				process_binary_operator ("!=", a_node)
			end
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- <Precursor>
		do
			process_binary_operator ("||", a_node)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- <Precursor>
		do
				-- TODO: include the shortcut semantics; for the moment, use the same semantics as ordinary "or"
			process_binary_operator ("||", a_node)
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- <Precursor>
		do
			process_binary_operator ("!=", a_node)
		end

	process_bin_tilde_b (a_node: BIN_TILDE_B)
			-- <Precursor>
		do
			if not a_node.left.type.is_boolean then
				process_leaf_node ("==", a_node)
			else
				process_binary_operator ("==", a_node)
			end

		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- <Precursor>
		do
			process_leaf_node (">=", a_node)
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- <Precursor>
		do
			process_leaf_node (">", a_node)
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- <Precursor>
		do
			process_leaf_node ("<=", a_node)
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- <Precursor>
		do
			process_leaf_node ("<", a_node)
		end

	process_bool_const_b (a_node: BOOL_CONST_B)
			-- <Precursor>
		do
			process_leaf_node ("", a_node)
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- <Precursor>
		do
			process_leaf_node ("", a_node)
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- <Precursor>
		do
			process_leaf_node ("", a_node)
		end

	process_instr_call_b (a_node: INSTR_CALL_B)
			-- <Precursor>
		do

		end

	process_tuple_access_b (a_node: TUPLE_ACCESS_B)
			-- <Precursor>
		do
			process_leaf_node ("", a_node)
		end

	process_access_expr_b (a_node: ACCESS_EXPR_B)
			-- <Precursor>
		do
			process_leaf_node ("", a_node)
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- <Precursor>
		local
			l_left: E2B_MCDC_NODE
		do
			safe_process (a_node.expr)
			l_left := last_node

			last_node := create {E2B_MCDC_NODE}.make ("!", l_left, Void)
			l_left.set_parent (last_node)

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
