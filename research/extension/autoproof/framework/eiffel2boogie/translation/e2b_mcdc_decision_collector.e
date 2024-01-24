class
	E2B_MCDC_DECISION_COLLECTOR

inherit

	E2B_BODY_EXPRESSION_TRANSLATOR
		redefine
			process_instr_call_b,
			process_argument_b,
			process_attribute_b,
			process_local_b,
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
			process_object_test_b,
			process_object_test_local_b,
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

feature -- Access

	is_boolean_expression: BOOLEAN
			-- Is the current expression a boolean expression?

feature -- Implementation

	check_and_add_decision (a_expr: EXPR_B)
			-- Check whether the current expression is a decision
		do
			if not is_boolean_expression then
				is_boolean_expression := True
				options.mcdc_decision_exprs.extend (a_expr)
			end
		end


feature -- Visitors

	process_instr_call_b  (a_node: INSTR_CALL_B)
			-- <Precursor>
		do
			Precursor (a_node)
			if a_node.call.type.is_boolean then
				check_and_add_decision (a_node.call)
			end
		end

	process_argument_b (a_node: ARGUMENT_B)
			-- <Precursor>
		do
			Precursor (a_node)
			if a_node.type.is_boolean then
				check_and_add_decision (a_node)
			end
		end

	process_attribute_b (a_node: ATTRIBUTE_B)
			-- <Precursor>
		do
			Precursor (a_node)
			if a_node.type.is_boolean then
					-- single boolean variable, mapped to a leaf node
				check_and_add_decision (a_node)
			end
		end

	process_local_b (a_node: LOCAL_B)
			-- <Precursor>
		do
			Precursor (a_node)
			if a_node.type.is_boolean then
					-- single boolean variable, mapped to a leaf node
				check_and_add_decision (a_node)
			end
		end

	process_bin_and_b (a_node: BIN_AND_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_and_then_b (a_node: B_AND_THEN_B)
			-- <Precursor>
		do
				-- TODO: include the shortcut semantics; for the moment, use the same semantics as ordinary "and"
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_implies_b (a_node: B_IMPLIES_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_eq_b (a_node: BIN_EQ_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_ne_b (a_node: BIN_NE_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_or_b (a_node: BIN_OR_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_or_else_b (a_node: B_OR_ELSE_B)
			-- <Precursor>
			-- local
			--	l_left, l_right: E2B_MCDC_NODE
		do
				-- TODO: include the shortcut semantics; for the moment, use the same semantics as ordinary "or"
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_xor_b (a_node: BIN_XOR_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_tilde_b (a_node: BIN_TILDE_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_ge_b (a_node: BIN_GE_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_gt_b (a_node: BIN_GT_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_le_b (a_node: BIN_LE_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_bin_lt_b (a_node: BIN_LT_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_object_test_b (a_node: OBJECT_TEST_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_object_test_local_b (a_node: OBJECT_TEST_LOCAL_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
		end

	process_un_not_b (a_node: UN_NOT_B)
			-- <Precursor>
		do
			check_and_add_decision (a_node)
			Precursor (a_node)
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
