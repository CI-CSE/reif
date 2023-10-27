note
	description: "Reduce the simplification task into a set of integer minimization tasks."

class
	E2B_VERIFY_WITH_OPTIMIZATION_TASK

inherit

	E2B_VERIFY_TASK

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (a_last_result: like last_result; a_target_feature: like target_feature; a_target_class: like target_class; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			last_result := a_last_result
			target_feature := a_target_feature
			target_class := a_target_class

			remaining_tasks := a_tasks
			has_next_step := True
			create l_translator_input.make
			create l_context
			create target_variables.make (0)
			create minimized_vars.make

		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	sleep_time: NATURAL = 0
			-- <Precursor>

	l_boogie_universe: IV_UNIVERSE

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>
		local
			j, k: INTEGER
			arg_name, file_prefix: STRING
			arg_type: TYPE_A
			pt: E2B_PROOF_TO_TEST_TARGET_FEATURE
		do
			create l_boogie_universe.make
			boogie_universe_cell.put (l_boogie_universe)

			l_context.options.routines_to_optimize.wipe_out
			failed_verifications := last_result.failed_verifications
			k := k + 1

			if attached target_feature and not l_context.options.routines_to_optimize.has (target_feature.body_index) then

				l_context.options.routines_to_optimize.extend (target_feature.body_index)
				create pt.make (target_feature, target_class)
				l_context.options.features_to_optimize.extend (pt)

				file_prefix := target_class.name + "." + target_feature.feature_name_32.to_string_8

				if not l_context.options.model_files.has (file_prefix) then
					l_context.options.model_files.extend (file_prefix)
				end

				minimize_var ("Current", target_class.actual_type) -- Minimize `Current'

				if attached target_feature.arguments then
					from
						j := 1
					until
						j > target_feature.arguments.count
					loop -- Minimize each argument of the target feature
						arg_name := target_feature.arguments.item_name_32 (j).to_string_8
						arg_type := target_feature.arguments.array_item (j - 1)
						-- print (arg_name + ": " + arg_type.base_class.name + "%N")

						if not options.init_states_of_counterexamples [k].is_aliased_with_existed_object (arg_name) then
							minimize_var (arg_name, arg_type)
						end
						j := j + 1
					end
				end

			end

			remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_feature, target_variables, failed_verifications, remaining_tasks))
			has_next_step := False -- has next routine to optimize
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature {NONE} -- Implementation

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.con

		-- initial_result_generator: attached E2B_RESULT_GENERATOR
		-- Boogie verifier.

	last_result: E2B_RESULT
			-- Result of the last verification run.

		-- optimization_verifier: detachable E2B_VERIFIER
		-- Boogie verifier.

	l_context: E2B_SHARED_CONTEXT
			-- Verification context

	target_feature: detachable FEATURE_I
			-- Feature under optimization

	target_class: detachable CLASS_C
			-- Class of the target feature

	target_variables: HASH_TABLE [LINKED_LIST [STRING], FEATURE_I]
			-- List of integer variables to be optimized

	failed_verifications: READABLE_INDEXABLE [E2B_FAILED_VERIFICATION]
			-- Verification failures

feature

	l_translator_input: E2B_TRANSLATOR_INPUT
			-- Translator for Boogie code

feature -- features for extending functionality for optimization

	minimize_var (a_var: STRING; a_type: TYPE_A)
			-- Minimize a variable
		local
			i: INTEGER
			type, attr_name: STRING
			attr_type: TYPE_A
		do
			minimized_vars.extend (a_var)

			type := a_type.base_class.name

			if is_integer_type (type) then -- Minimize integer
				add_target_variable (a_var)
					-- v := get_value_from_counterexample (a_var)
					-- if v > 0 then
					-- minimize_int (a_var, v, False, False)
					--	remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_feature, a_var, v, False, False, remaining_tasks))
					-- elseif v < 0 then
					-- minimize_int (a_var, v, True, False)
					--	remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_feature, a_var, v, True, False, remaining_tasks))
					-- end

			elseif is_reference_type (type) then -- Minimize container

				if is_container_type (type) then
					add_target_variable (a_var + ".count")
					add_opt_container (a_var, a_type)
						-- reduce into integers, sequence_item

						-- TODO: find the correct name of sequence size
						-- container
						-- v := get_value_from_counterexample (a_var + ".count")
						-- minimize_int (a_var + ".count", v, False, True)
						-- remaining_tasks.extend (create {E2B_VERIFY_TO_OPTIMIZE_INTEGER_TASK}.make (l_boogie_universe, target_class, target_feature, a_var + ".count", v, False, True, remaining_tasks))
						-- v := get_value_from_counterexample (a_var + ".count")
						-- from
						--	i := 1
						-- until
						--	i > v
						-- loop
						--	minimize_var (a_var + "[" + i.out + "]", a_type.actual_type)
						--	i := i + 1
						-- end
				else
					from
						i := 1
					until
						i > a_type.base_class.skeleton.count
					loop
						attr_name := a_type.base_class.skeleton [i].attribute_name
						attr_type := a_type.base_class.skeleton [i].type_i
						minimize_var (a_var + "." + attr_name, attr_type)
						i := i + 1
					end
				end
			end
		end

	is_container_type (a_type: STRING): BOOLEAN
			-- Is `a_type' a container type?
		do
			Result := a_type.same_string ("SIMPLE_ARRAY") or a_type.same_string ("V_ARRAY")
		end

	is_integer_type (a_type: STRING): BOOLEAN
			-- Is `a_type' an integer type?
		do
			Result := a_type.same_string ("INTEGER") or a_type.same_string ("INTEGER_8") or a_type.same_string ("INTEGER_16") or a_type.same_string ("INTEGER_32")
		end

	is_reference_type (a_type: STRING): BOOLEAN
			-- Is 	`a_type' a reference type?
		do
			Result := not is_integer_type (a_type) and not a_type.same_string ("BOOLEAN") and not a_type.same_string ("REAL") and
				not a_type.same_string ("CHARACTER")
		end

	add_target_variable (a_var: STRING)
			-- Add `a_var' to the groups of target variables
		do
			if target_variables.has (target_feature) then
				target_variables [target_feature].extend (a_var)
			else
				target_variables.extend (create {LINKED_LIST [STRING]}.make_from_iterable (<<a_var>>), target_feature)
			end
		end

	minimized_vars: LINKED_LIST [STRING]
			-- A list of minimized variables

	add_opt_container (a_var: STRING; a_type: TYPE_A)
			-- Add `a_var' to the list of containers to be optimized
		do
			l_context.options.container_to_optimize.force (a_type.twin, a_var.twin)
		end

note
	date: "$Date: 2022-01-18 20:46:44 +0100 (Tue, 18 Jan 2022) $"
	revision: "$Revision: 106120 $"
	copyright:
		"Copyright (c) 2012-2014 ETH Zurich",
		"Copyright (c) 2018 Politecnico di Milano",
		"Copyright (c) 2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Alexander Kogtenkov"
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
