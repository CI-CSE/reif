note
	description: "Summary description for {IV_BOOGIE_CONTRADICTION_PRINTER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	IV_BOOGIE_SEEDED_CONTRADICTION_PRINTER

inherit
	IV_BOOGIE_PRINTER
		redefine
			make,
			process_procedure,
			process_implementation,
			process_block,
			process_conditional,
			process_procedure_call,
			process_precondition
		end

create
	make

feature {NONE} -- Initialization
	make
			-- Initialize universe visitor
		do
			Precursor
			create uncovered_branch_lines.make_empty
		end

feature -- Universe Visitor

	process_precondition (a_precondition: IV_PRECONDITION)
			-- <Precursor>
		do
			output.put_indentation
			if a_precondition.is_free then
				output.put ("free ")
			end
			output.put ("requires ")
			if attached a_precondition.attribute_string then
				output.put ("{" + a_precondition.attribute_string + "} ")
			end
			a_precondition.expression.process (Current)
			output.put (";")
			print_node_info (a_precondition.node_info)
			output.put_new_line
		end

	process_procedure (a_procedure: IV_PROCEDURE)
			-- <Precursor>
		do
			is_full_coverage_tests_enabled := a_procedure.is_full_coverage_tests_enabled
			is_mcdc_tests_enabled := a_procedure.is_mcdc_tests_enabled
			is_generate_fix_enabled := a_procedure.is_generate_fix_enabled

			uncovered_branch_lines.copy (a_procedure.uncovered_branch_lines)
			block_index := 0

			output.put ("procedure ")
			output.put (a_procedure.name)
			output.put ("(")
			across a_procedure.arguments as i loop
				if @ i.cursor_index /= 1 then
					output.put (", ")
				end
				process_entity_declaration (i)
			end

			if is_full_coverage_tests_enabled then
					-- if a_procedure.has_conditional and is_full_coverage_tests_enable then
				branch_number := 0
			end

			output.put (")")
			if not a_procedure.results.is_empty then
				output.put (" returns (")
				across a_procedure.results as i loop
					if @ i.cursor_index /= 1 then
						output.put (", ")
					end
					process_entity_declaration (i)
				end
				output.put (")")
			end
			output.put (";")
			output.put_new_line
			output.indent
			across a_procedure.contracts as i loop
				i.process (Current)
			end

			across a_procedure.opt_preconditions as p loop
				if not p.same_string ("") then
					output.put ("  free ")
					output.put ("requires " + p)
					output.put (";%N")
				end
			end

			output.unindent
			output.put_new_line
			across a_procedure.implementations as i loop
				i.process (Current)
			end
			output.put_new_line
			output.put_new_line
		end

	process_implementation (a_implementation: IV_IMPLEMENTATION)
			-- <Precursor>
		do
			context_procedure := a_implementation.procedure
			output.put ("implementation ")
			output.put (a_implementation.procedure.name)
			output.put ("(")
			across a_implementation.procedure.arguments as i loop
				if @ i.cursor_index /= 1 then
					output.put (", ")
				end
				output.put (i.name)
				output.put (": ")
				i.type.process (Current)
			end

			if is_full_coverage_tests_enabled then
					-- if a_implementation.has_conditional and is_full_coverage_tests_enable then
				branch_number := 0
			end
			output.put (")")
			if not a_implementation.procedure.results.is_empty then
				output.put (" returns (")
				across a_implementation.procedure.results as i loop
					if @ i.cursor_index /= 1 then
						output.put (", ")
					end
					output.put (i.name)
					output.put (": ")
					i.type.process (Current)
				end
				output.put (")")
			end
			output.put_new_line
			output.put ("{")
			output.put_new_line
			output.indent

				-- Use a boolean sequence to track the passed blocks in the counterexample execution
				-- if is_generate_fix_enabled then
				-- output.put_indentation
				-- output.put ("var ")
				-- output.put ("passed_blocks: Seq bool;")
				-- output.put_new_line
				-- end

			if not a_implementation.locals.is_empty or not a_implementation.procedure.results.is_empty then
				across a_implementation.locals as i loop
					output.put_indentation
					output.put ("var ")
					process_entity_declaration (i)
					output.put (";")
					output.put_new_line
				end

				if is_full_coverage_tests_enabled then
					output.put ("var bnu: int;")
					output.put_new_line
				end

				output.put_new_line
				output.put_line ("init_locals:")

				across a_implementation.locals as i loop
						-- No defaults needed for auxiliary locals of Boogie types, like HeapType:
					if i.type.default_value /= Void then
						output.put_indentation
						output.put (i.name)
						output.put (" := ")
						i.type.default_value.process (Current)
						output.put (";")
						output.put_new_line
					end
				end

				across a_implementation.procedure.results as i loop
					output.put_indentation
					output.put (i.name)
					output.put (" := ")
					i.type.default_value.process (Current)
					output.put (";")
					output.put_new_line
				end
				output.put_new_line
			end

				-- TODO: remove the following snippet
			if a_implementation.procedure.name.has_substring ("linear_search") then
				output.put_indentation
				output.put ("Result := 1;")
				output.put_new_line
			end

			if is_full_coverage_tests_enabled and not a_implementation.procedure.name.has_substring ("default_create")
				and not a_implementation.procedure.is_ghost_or_lemma_feature and not a_implementation.has_conditional then
				seed_contradiction
			end

			a_implementation.body.process (Current)
			output.unindent
			output.put ("}")
			output.put_new_line
			output.put_new_line
		end

	process_block (a_block: IV_BLOCK)
			-- <Precursor>
		do
			block_index := block_index + 1
			if is_generate_fix_enabled then
				output.put_indentation
				output.put ("passed_blocks := Seq#Update(passed_blocks, " + block_index.out + ", true);")
			end

			if not a_block.name.is_empty then
				output.put_indentation
				output.put (a_block.name)
				output.put (":")
				output.put_new_line
			end

				-- Loop body that does not contain branches
			if a_block.is_loop_body_block and then a_block.is_conditional_leaf (False, Void) and not a_block.is_unrolled_block then
				seed_conditional_contradiction
			end

			across a_block.statements as i loop
				print_statement_origin_information (i)
				i.process (Current)
			end

		end

	seed_contradiction
			-- Add a plain contradiction statement, given in the form of ``assert false''
		do
			output.put_indentation
			output.put ("assert false;")
			output.put_new_line
		end

	seed_conditional_contradiction
			-- Add a conditional contradiction statement, given in the form of ``if (bn == branch_number) {assert false}''
		do
			branch_number := branch_number + 1
			output.put_line ("if ((bn) == (" + branch_number.out + ")) {assert false;}")
			output.put_new_line
		end

	seed_branch_number_assignment
			-- Add an assignment of the branch number to `bn';
			-- Given in the form `` bn := branch_number''
		do
			unrolled_branch_number := unrolled_branch_number + 1
			output.put_line ("bnu  := " + unrolled_branch_number.out + ";")
			output.put_new_line
		end

	process_conditional (a_conditional: IV_CONDITIONAL)
		do
			output.put_indentation
			output.put ("if (")
			if a_conditional.condition = Void then
				output.put ("*) {")
			else
				a_conditional.condition.process (Current)
				output.put (") {")

				if is_full_coverage_tests_enabled and then not a_conditional.is_current_feature_ghost and then a_conditional.then_block.is_conditional_leaf (true, a_conditional.origin_information) then
						-- and then uncovered_branch_lines.has (a_conditional.then_block.origin_information.line) then
					if (is_mcdc_tests_enabled and then a_conditional.then_block.is_empty) or (not is_mcdc_tests_enabled) then
						if a_conditional.then_block.is_unrolled_block then
							seed_branch_number_assignment
						else
							seed_conditional_contradiction
						end
					end
				end

			end
			output.put_new_line
			output.indent
			a_conditional.then_block.process (Current)
			output.unindent
			if not a_conditional.else_block.is_empty then
				output.put_line ("} else {")
				output.indent
					-- insert "assert false" into the else_block of the leaf if/elseif conditional
				if is_full_coverage_tests_enabled and not is_mcdc_tests_enabled
					and not a_conditional.is_current_feature_ghost
					and then a_conditional.else_block.is_conditional_leaf (false, a_conditional.origin_information) then
					if a_conditional.else_block.is_unrolled_block then
						seed_branch_number_assignment
					else
						seed_conditional_contradiction
					end
				end
				a_conditional.else_block.process (Current)
				output.unindent
			elseif is_full_coverage_tests_enabled and then not is_mcdc_tests_enabled
				and then not a_conditional.is_current_feature_ghost
				and then a_conditional.condition /= Void then
					-- implicit else branch
				output.put_line ("} else {")
				if a_conditional.then_block.is_unrolled_block then
					seed_branch_number_assignment
				else
					seed_conditional_contradiction
				end
			end
			output.put_line ("}")
		end

	process_procedure_call (a_call: IV_PROCEDURE_CALL)
			-- <Precursor>
		local
			l_old_count: INTEGER
			l_parameters: LIST [STRING]
		do
			output.put_indentation
			output.put ("call ")
			if attached a_call.target as l_target then
				l_target.process (Current)
				output.put (" := ")
			end
			output.put (a_call.name)
			output.put ("(")
			l_old_count := output.string.count
			across a_call.arguments as i loop
				if @ i.cursor_index /= 1 then
					output.put (", ")
				end
				i.process (Current)
			end
			l_parameters := output.string.tail (output.string.count - l_old_count).split (',') -- list of parameters
			output.put (");")

			print_node_info (a_call.node_info)
			output.put_new_line
		end

feature {NONE} -- Implementation

	is_full_coverage_tests_enabled: BOOLEAN
			-- Is full-coverage test generation enabled?

	is_mcdc_tests_enabled: BOOLEAN
			-- Is full-coverage test generation enabled?

	is_generate_fix_enabled: BOOLEAN
			-- Is generating fix enabled?

	uncovered_branch_lines: ARRAY [INTEGER]
			-- Uncovered branches lines in the latest test generation run

	branch_number: INTEGER
			-- Number of branches in the current procedure

	unrolled_branch_number: INTEGER
			-- Number of branches from unrolled loop body in the current procedure

	block_index: INTEGER
			-- Index of the current block

	context_procedure: IV_PROCEDURE
			-- The procedure under processing

	;

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
