note
	description: "Task to re-verify with inlining."

class
	E2B_COMPUTE_FIX_ELEMENT_TASK

inherit

	E2B_VERIFY_TASK -- TODO: replace it with ROTA task?

	E2B_SHARED_CONTEXT

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialization

	make (a_initial_result_generator: attached like initial_result_generator; a_tasks: like remaining_tasks)
			-- Initialize task.
		do
			-- print ("E2B_COMPUTE_FIX_ELEMENT_TASK.make%N")
			initial_result_generator := a_initial_result_generator
			remaining_tasks := a_tasks
			has_next_step := True
			create l_context
			options.increase_number_of_iterations
		end

feature -- Status report

	has_next_step: BOOLEAN
			-- <Precursor>

	sleep_time: NATURAL = 0
			-- <Precursor>

feature {ROTA_S, ROTA_TASK_I} -- Basic operations

	step
			-- <Precursor>120
			-- local
			--	l_translator_input: E2B_TRANSLATOR_INPUT
			-- 	l_boogie_universe: IV_UNIVERSE
			-- l_context: E2B_SHARED_CONTEXT
		do
			-- print ("E2B_COMPUTE_FIX_ELEMENT_TASK.step%N")
			options.set_generate_fix_enabled (False)
			-- compute_range
			-- compute_fix

			store_ce_traces

			print (Msg_ce_generated +  ce_trace_file_name + "%N")

			if not options.fix_preconditions.is_empty then
				options.set_current_candidate_fix(options.fix_preconditions.first)
			end
			options.ce_traces.wipe_out
			has_next_step := False
		end

	cancel
			-- <Precursor>
		do
			has_next_step := False
		end

feature

	compute_fix
			-- Compute preconditions for fixing the program
		do
			across options.fix_elements as e loop
					-- ce range: [e.max, e.min]
					-- opposite of ce range:
					-- e.is_constant: e.var /= e.max
					-- not e.is_constant: 1) e.var < e.min 2) e.var > e.max
					-- get the weakest possible fixes and display to the user -- construct the fix_message
				target_variable := e.var_name
				if e.is_constant then
					options.fix_preconditions.extend (get_variable_name + " != " + e.max.out)
				else
					options.fix_preconditions.extend (get_variable_name + " > " + e.max.out)
					options.fix_preconditions.extend (get_variable_name + " < " + e.min.out)
				end
					-- TODO: combination/arbitrary conjunction of the elementary predicate
			end

			remaining_tasks.extend (create {E2B_VERIFY_FOR_FIX_EVALUATE_TASK}.make (options.target_feature, options.last_result.failed_verifications, initial_result_generator, remaining_tasks))

		end

	compute_range
			-- Compute possible ranges
		local
			e: E2B_FIX_ELEMENT
			var: READABLE_STRING_32
			i: INTEGER
			value, n, l_min, l_max: INTEGER
		do
				-- Get the number of variables
			n := options.ce_states.first.locals.count
			from
				i := 2
			until
				i > n
			loop -- loop over all counterexamples to get the minimal/maximum of each variable
				var := options.ce_states.first.locals.current_keys [i]
				create e.make (var)
				value := safe_value (options.ce_states.first.locals [var])
				l_max := value
				l_min := value

				across options.ce_states as ce loop
					value := safe_value (ce.locals [var])
					if value > l_max then
						l_max := value
					elseif value < l_min then
						l_min := value
					end
				end
				e.set_max (l_max)
				e.set_min (l_min)

				options.fix_elements.extend (e)

				-- print (var.to_string_8 + " interval: [" + l_min.out + ", " + l_max.out + "]%N")
				i := i + 1
			end

		end

	safe_value (val: READABLE_STRING_GENERAL): INTEGER
			-- Convert from string to a valid integer
		local
			s: READABLE_STRING_GENERAL
		do
			s := val
			if s.has ('(') then
				s := s.substring (2, s.count - 1)
			end
			Result := s.to_integer
		end

	get_variable_name: STRING
			-- Variable name in the boogie code
		local
			object_name, object_type, field_name: STRING
		do
			if target_variable.has ('.') then
				object_name := target_variable.split ('.').first
				if is_container_size then
						-- free requires (fun.SIMPLE_ARRAY^INTEGER_32^.count(Heap, a)) >= (0) && (fun.SIMPLE_ARRAY^INTEGER_32^.count(Heap, a)) <= 12955;
					object_type := l_context.options.container_to_optimize [object_name].name
					Result := "(fun." + safe_type (object_type) + ".count(Heap, " + object_name + "))"
				elseif is_container_item then
						-- (Seq#Item(Heap[a, SIMPLE_ARRAY^INTEGER_32^.sequence], i_2)
					object_type := l_context.options.container_to_optimize [object_name].name
					Result := "(Seq#Item(Heap[" + object_name + ", " + safe_type (object_type) + ".sequence], " + target_variable.split ('.').last.to_string_8 + "))"

				else
					field_name := options.target_class.actual_type.name + "." + target_variable.split ('.').last
					Result := "Heap[" + object_name + ", " + field_name + "]"
				end

			else
				Result := target_variable
			end
		end


	store_ce_traces
			-- Generate a test from a single counterexample model
		do
			across options.ce_traces.current_keys as k loop
				ce_trace_file_name := system.eiffel_project.project_directory.path.extended (k.to_string_8 + ".txt").out
				create ce_trace_file.make_create_read_write (ce_trace_file_name)
				-- ce_trace_file.put_string (k.to_string_8 + "%N")
				across options.ce_traces [k] as t loop
					ce_trace_file.put_string (t.out)
					ce_trace_file.flush
				end
				ce_trace_file.close
			end
		end


feature {NONE} -- Implementation

	remaining_tasks: attached LINKED_LIST [ROTA_TASK_I]
			-- List of remaining tasks.

	initial_result_generator: attached E2B_RESULT_GENERATOR
			-- Boogie verifier.

	l_context: E2B_SHARED_CONTEXT
			-- Verification context

	target_variable: STRING
			-- Name of the target variable

	ce_trace_file_name: STRING
			-- Path of the ce trace file

	ce_trace_file: PLAIN_TEXT_FILE
			-- Output .txt file that storeds all ce traces

	file_index: INTEGER
			-- File index of the ce trace file

	is_container_size: BOOLEAN
			-- Is the target variable the size of a container
		do
			Result := target_variable.has_substring (".count")
		end

	is_container_item: BOOLEAN
			-- Is the target variable the item of a container
		do
			Result := target_variable.has_substring (".item")
		end

	safe_type (type: STRING): STRING
			-- Convert the name of container type
		local
			t, item_type: STRING
			tuple_field_types: LIST [STRING]
			i: INTEGER
		do
			t := ""; Result := ""; item_type := ""

			if type.has_substring ("[") then
				if type.has_substring ("V_ARRAY") then
					item_type.copy (type.split ('[') [2].split (']').first)
					t := t + "V_ARRAY" + "^" + item_type + "^"
				elseif type.has_substring ("SIMPLE_ARRAY") then
					item_type.copy (type.split ('[') [2].split (']').first)
					t := t + "SIMPLE_ARRAY" + "^" + item_type + "^"
				elseif type.has_substring ("LIST") then
					item_type.copy (type.split ('[') [2].split (']').first)
					t := t + "LIST" + "^" + item_type + "^"
				elseif type.has_substring ("TUPLE") then
					tuple_field_types := type.split ('#')
					tuple_field_types [1].copy (tuple_field_types [1].split ('^').last)
					t := t + "TUPLE" + "^"

					from
						i := 1
					until
						i = tuple_field_types.count
					loop
						t := t + tuple_field_types [i] + ","
						i := i + 1
					end

					t := t + tuple_field_types [i].split (']').first + "^"
				end
			else
				t := type
			end
			Result.copy (t)
		end

	Msg_ce_generated: STRING = "<[- CE generated ]>"
;

note
	date: "$Date: 2022-01-19 03:46:44 +0800 (Wed, 19 Jan 2022) $"
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
