class
	E2B_RESULT_GENERATOR

inherit

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize.
		do
		end

feature -- Access

	last_result: detachable E2B_RESULT
			-- Last generated result.

	local_autoproof_errors: like autoproof_errors
			-- Local list of AutoProof errors (in case global list needs to be wiped).

	local_result_handlers: like result_handlers
			-- Local list of Result handlers (in case global list needs to be wiped).

feature -- Element change

	store_global_state
			-- Store global state of AutoProof for processing with this result generator.
		do
			local_autoproof_errors := autoproof_errors.twin
			local_result_handlers := result_handlers.twin
		end

feature -- Basic operations

	process_boogie_result (a_boogie_result: E2B_BOOGIE_RESULT)
			-- Process `a_boogie_result'.
		local
			l_ap_error: E2B_AUTOPROOF_ERROR
		do
			create last_result.make
				-- Use global list if local one is empty
			if local_autoproof_errors = Void then
				local_autoproof_errors := autoproof_errors
			end

				-- Add AutoProof errors
			last_result.verification_results.append (local_autoproof_errors)

				-- Add Boogie errors (if there were no validity errors)
			if across local_autoproof_errors as i all i.is_warning end then
				across a_boogie_result.boogie_errors as i loop
					create l_ap_error
					l_ap_error.set_type ("Boogie")
					l_ap_error.set_message ({UTF_CONVERTER}.utf_8_string_8_to_string_32 (i))
						-- last_result.verification_results.extend (l_ap_error)
				end
			end
				-- Call result handler for each Boogie procedure
			across a_boogie_result.procedure_results as i loop
				process_procedure_result (i)
			end
		end

	process_individual_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR; a_failure: E2B_FAILED_VERIFICATION)
			-- Handle individual Boogie procedure error.
		local
			l_error: E2B_DEFAULT_VERIFICATION_ERROR
			l_init_state: E2B_INITIAL_STATE_OF_ROUTINE
		do
			create l_error.make (a_failure)

				-- Get input values in counterexample
			create l_init_state.make (a_failure.context_feature, a_failure.context_class, a_error.counterexample)

			helper.options.init_states_of_counterexamples.extend (l_init_state)

			a_failure.errors.extend (l_error)
			l_error.set_boogie_error (a_error)

			l_error.set_message (message_for_error (a_error, l_init_state))
			l_error.set_ce_message (counterexample_message (l_init_state))
			l_error.set_ce_init_state (l_init_state)
			
		    helper.options.set_current_init_state (l_init_state)

            if helper.options.target_error_index = a_failure.errors.count then -- what is this statement about?
                helper.options.set_new_ce_message(l_error.ce_message)
            end

            if helper.options.is_generate_fix_enabled then
            	 helper.options.ce_states.extend (l_init_state)
            end

			l_error.set_line_number (line_for_error (a_error))
		end

	has_validity_error (a_feature: FEATURE_I; a_class: CLASS_C): BOOLEAN
			-- Does `a_feature' in `a_class' have a validty error (or the whole class if `a_feature' is Void),
		require
			a_class_exists: attached a_class
		local
			l_errors: LIST [E2B_AUTOPROOF_ERROR]
			l_error: E2B_AUTOPROOF_ERROR
		do
			from
				l_errors := last_result.autoproof_errors
				l_errors.start
			until
				l_errors.after or Result
			loop
				l_error := l_errors.item
				Result := not l_error.is_warning and
					helper.is_same_class (l_error.context_class, a_class) and then
					((l_error.context_feature = Void) or else -- The whole class has an error
						(a_feature /= Void and then l_error.context_feature.rout_id_set.first = a_feature.rout_id_set.first)) -- or we are asking about a feature and that feature has an error
				l_errors.forth
			end
		end

feature {NONE} -- Implementation

	process_procedure_result (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Process procedure result.
		local
			l_agent: PROCEDURE [E2B_BOOGIE_PROCEDURE_RESULT, E2B_RESULT_GENERATOR]
		do
				-- Use global list if local one is empty
			if local_result_handlers = Void then
				local_result_handlers := result_handlers
			end
			if local_result_handlers.has_key (a_item.name) then
				l_agent := local_result_handlers [a_item.name]
				l_agent.call ([a_item, Current])
			else
				process_default_result (a_item)
			end
		end

	process_default_result (a_item: E2B_BOOGIE_PROCEDURE_RESULT)
			-- Default handler for Boogie procedure results.
		local
			l_temp: like name_translator.feature_for_boogie_name
			l_feature: FEATURE_I
			l_context: STRING
			l_success: E2B_SUCCESSFUL_VERIFICATION
			l_inconclusive: E2B_INCONCLUSIVE_RESULT
			l_failure: E2B_FAILED_VERIFICATION
		do
			l_temp := name_translator.feature_for_boogie_name (a_item.name)
			l_feature := l_temp.feature_
			check l_feature /= Void end

			if l_temp.is_creator then
				l_context := "creator"
			end
			if l_temp.type.base_class.class_id /= l_feature.written_in then
				if l_context = Void then
					l_context := ""
				else
					l_context.append (", ")
				end
				l_context.append ("inherited by " + l_temp.type.base_class.name_in_upper)
			end

			if has_validity_error (l_feature, l_temp.type.base_class) then
					-- Ignore results of features with a validity error
			elseif a_item.is_successful then
				create l_success
				l_success.set_feature (l_feature)
				l_success.set_verification_context (l_context)
				l_success.set_time (a_item.time)
				last_result.add_result (l_success)
			elseif a_item.is_inconclusive then
				create l_inconclusive.make
				l_inconclusive.set_feature (l_feature)
				l_inconclusive.set_verification_context (l_context)
				last_result.add_result (l_inconclusive)
			else
				check a_item.is_error end
				create l_failure.make
				l_failure.set_feature (l_feature)
				l_failure.set_verification_context (l_context)
				l_failure.set_time (a_item.time)

				across a_item.errors as i loop
					process_individual_error (i, l_failure)
				end
				last_result.add_result (l_failure)
			end
		end

	message_for_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR; a_init_state: E2B_INITIAL_STATE_OF_ROUTINE): STRING_32
			-- Select message for `a_error'.
		local
			l_type, l_tag: STRING
			l_has_tag: BOOLEAN

		do
			if a_error.has_related_location then
					-- It's a pre- or postcondition violation
				l_type := a_error.related_attributes ["type"]
				l_tag := a_error.related_attributes ["tag"]
				l_has_tag := a_error.related_attributes.has_key ("tag")
			else
				l_type := a_error.attributes ["type"]
				l_tag := a_error.attributes ["tag"]
				l_has_tag := a_error.attributes.has_key ("tag")
			end

			if l_type ~ "check" then
					-- Check violation
				if l_has_tag then
					if l_tag ~ "function_precondition" then
						Result := messages.function_precondition_violated
					else
						Result := messages.check_with_tag_violated
					end
				else
					Result := messages.check_violated
				end
			elseif l_type ~ "pre" then
					-- Precondition violation
				if l_has_tag then
					Result := messages.precondition_with_tag_violated
				else
					Result := messages.precondition_violated
				end
			elseif l_type ~ "post" then
					-- Postcondition violation
				if l_has_tag then
					Result := messages.postcondition_with_tag_violated
				else
					Result := messages.postcondition_violated
				end
			elseif l_type ~ "inv" then
					-- Inline invariant check violation
				if l_has_tag then
					Result := messages.invariant_with_tag_violated
				else
					Result := messages.invariant_violated
				end
			elseif l_type ~ "loop_inv" then
				if a_error.is_loop_inv_violated_on_entry then
					if l_has_tag then
						Result := messages.loop_inv_with_tag_violated_on_entry
					else
						Result := messages.loop_inv_violated_on_entry
					end
				else
--					check a_error.is_loop_inv_not_maintained end
					if l_has_tag then
						Result := messages.loop_inv_with_tag_not_maintained
					else
						Result := messages.loop_inv_not_maintained
					end
				end
			elseif l_type ~ "attached" then
					-- Possible void call
				if a_error.is_assert_error then
					Result := messages.void_call
				elseif a_error.is_precondition_violation then
					if l_has_tag then
						Result := messages.void_call_in_precondition_with_tag
					else
						Result := messages.void_call_in_precondition
					end
				elseif a_error.is_postcondition_violation then
					if l_has_tag then
						Result := messages.void_call_in_postcondition_with_tag
					else
						Result := messages.void_call_in_postcondition
					end
				else
					Result := messages.void_call
				end
			elseif l_type ~ "termination" then
				check a_error.is_assert_error end
				check l_has_tag end
				if l_tag ~ "variant_decreases" then
					Result := messages.decreases_not_decreasing
				elseif l_tag ~ "bounded" then
					Result := messages.decreases_bounded
				else
					check internal_error: False end
				end
			elseif l_type ~ "overflow" then
					-- Arithmetic overflow
				if a_error.is_assert_error then
					Result := messages.overflow
				elseif a_error.is_precondition_violation then
					if l_has_tag then
						Result := messages.overflow_in_precondition_with_tag
					else
						Result := messages.overflow_in_precondition
					end
				elseif a_error.is_postcondition_violation then
					if l_has_tag then
						Result := messages.overflow_in_postcondition_with_tag
					else
						Result := messages.overflow_in_postcondition
					end
				else
					Result := messages.overflow
				end
			elseif l_type ~ "assign" then
					-- Attribute update failed
--				check a_error.is_precondition_violation end
				check l_has_tag end
				if l_tag ~ "attached_and_allocated" then
					Result := messages.assignment_attached_and_allocated
				elseif l_tag ~ "closed_or_owner_not_allowed" then
					Result := messages.assignment_closed_or_owner_not_allowed
				elseif l_tag ~ "target_open" then
					Result := messages.assignment_target_open
				elseif l_tag ~ "observers_open_or_guard_holds" then
					Result := messages.assignment_observers_open_or_guard_holds
				elseif l_tag ~ "attribute_writable" then
					Result := messages.assignment_attribute_writable
				else
					check internal_error: False end
				end
			elseif l_type ~ "access" then
					-- Heap access failed
				check l_has_tag end
				if l_tag ~ "attribute_readable" then
					Result := messages.access_attribute_readable
				elseif l_tag ~ "frame_readable" then
					Result := messages.access_frame_readable
				else
					check internal_error: False end
				end
			else
					-- default error message
				if l_has_tag then
					Result := {STRING_32} "$type error with tag $tag."
				else
					Result := {STRING_32} "$type error."
				end
			end
			if a_error.is_postcondition_violation then
				if a_error.related_attributes.has_key ("default") then
					Result := Result + " " + messages.ownership_explicit_note
				end
			else
				if a_error.attributes.has_key ("default") then
					Result := Result + " " + messages.ownership_explicit_note
				end
			end

		end

	safe_var (a_var: STRING_32): STRING_32
			-- Remove "Current" in `a_var' if any
		do
			if a_var.has_substring ("Current.") then
				Result := a_var.split ('.').last
			else
				Result := a_var
			end
		end

	valuation (a_var: STRING_32; a_value: STRING_32): STRING_32
			-- String of a valuation
		local
			value: STRING_32
		do
			value := a_value
			if value.head (1).same_string ("(") then
				value.remove_head (1)
			end
			if value.tail (1).same_string (")") then
				value.remove_tail (1)
			end
			Result := safe_var (a_var) + " = " + value
		end

	counterexample_message (a_initial_state: E2B_INITIAL_STATE_OF_ROUTINE): STRING_32
			-- Message for displaying all tuples of values and variables in the counterexample
		local
			i, j: INTEGER
			var, value, seq_name, item_value, aliased_object: STRING_32
		do
			Result := ""
			aliased_object := ""

			from
				i := 1
			until
				i > a_initial_state.initial_values.count
			loop
				var := a_initial_state.initial_values.current_keys [i]
				value := a_initial_state.initial_values [var]

					-- sequence
				if not value.has_substring ("T@U") and not var.split ('.').first.same_string (aliased_object) and not value.is_empty then -- valuations
					Result := Result + " " + valuation (var, value) + ","

				elseif a_initial_state.is_aliased_with_existed_object (var) then -- alias relation
					Result := Result + " " + valuation (var, a_initial_state.alias_groups [value] [1]) + ","
					aliased_object := var
						-- Current.person -- TODO: handle the case where the field is also a reference -- need to improve AutoProof/Boogie first
				elseif var.split ('.').last.same_string ("sequence") then
					seq_name := var.split ('.').first
					if a_initial_state.ce.seq_lengths.has (value) then
						Result := Result + " " + valuation (seq_name + ".count", a_initial_state.ce.seq_lengths [value]) + ","

						if not a_initial_state.ce.seq_item.is_empty then
							from
								j := 1
							until
								j > a_initial_state.ce.seq_lengths [value].to_integer_32
							loop
								if a_initial_state.ce.seq_item.has (value + ", " + j.out) then
									item_value := a_initial_state.ce.seq_item [value + ", " + j.out]
									Result := Result + " " + valuation (seq_name + " [" + j.out + "]", item_value.to_string_8) + ","
								end
								j := j + 1
							end
						else
							Result := Result + " -- No sequence for array " + seq_name + "found in the model. %N"
						end
					end
				end
				i := i + 1
			end

			Result.remove_tail (1) -- remove the last comma
			Result.append (".")
		end

	line_for_error (a_error: E2B_BOOGIE_PROCEDURE_ERROR): INTEGER
			-- Select line number for `a_error'.
		do
			if a_error.is_postcondition_violation then
				if a_error.related_attributes.has_key ("line") then
					Result := a_error.related_attributes ["line"].to_integer
				end
			else
				if a_error.attributes.has_key ("line") then
					Result := a_error.attributes ["line"].to_integer
				end
			end
		end

note
	date: "$Date$"
	revision: "$Revision$"
	copyright:
		"Copyright (c) 2013-2014 ETH Zurich",
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
