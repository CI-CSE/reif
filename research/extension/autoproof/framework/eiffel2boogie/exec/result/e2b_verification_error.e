note
	description: "[
		Individual verifiation error.
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_VERIFICATION_ERROR

feature {NONE} -- Initialization

	make (a_parent: E2B_VERIFICATION_RESULT)
			-- Initialize verification error.
		do
			verification_result := a_parent
		end

feature -- Access

	verification_result: E2B_VERIFICATION_RESULT
			-- Related verification result.

	context_feature: detachable E2B_FEATURE_I
			-- Related Eiffel feature (if any).
		do
			Result := verification_result.context_feature
		end

	context_class: detachable E2B_CLASS_C
			-- Related Eiffel class (if any).
		do
			Result := verification_result.context_class
		end

	context_line_number: INTEGER
			-- Related Eiffel line number (if any).

	ce_init_state: detachable E2B_INITIAL_STATE_OF_ROUTINE
			-- Initial state extracted from the corresponding counterexample

feature -- Display

	set_ce_init_state (a_ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE)
			-- Set `ce_init_state' to `a_init_state'.
		do
			ce_init_state := a_ce_init_state
		end

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this error.
		deferred
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- Multi line description of this error.
		do
			single_line_message (a_formatter)
			if ce_init_state /= Void then
				a_formatter.add_new_line
				a_formatter.process_basic_text (counterexample_message_string)
			end
		end

	counterexample_message_string: detachable STRING
			-- Multi-line counterexample text
		do
			if attached ce_init_state as state then
				Result := ce_message_string (state)
			end
		end

feature {NONE} -- Counterexample text generation

	ce_message_string (state: E2B_INITIAL_STATE_OF_ROUTINE): STRING
			-- Message for displaying all tuples of values and variables in the counterexample
		require
			state /= Void
		local
			i, j: INTEGER
			var, value, seq_name, item_value, aliased_object: STRING
			values: LINKED_LIST [STRING]
		do
			aliased_object := ""
			create values.make

			from
				i := 1
			until
				i > state.initial_values.count
			loop
				var := state.initial_values.current_keys [i]
				value := state.initial_values [var]
					-- sequence
				if not value.has_substring ("T@U") and not var.split ('.').first.same_string (aliased_object) and not value.is_empty then -- valuations
					values.extend (valuation (var, value))
				elseif state.is_aliased_with_existed_object (var) then -- alias relation
					values.extend (valuation (var, state.alias_groups [value] [1]))
					aliased_object := var
					-- Current.person -- TODO: handle the case where the field is also a reference -- need to improve AutoProof/Boogie first
				elseif var.split ('.').last.same_string ("sequence") then
					seq_name := var.split ('.').first
					if state.ce.seq_lengths.has (value) then
						values.extend (valuation (seq_name + ".count", state.ce.seq_lengths [value]))

						if not state.ce.seq_item.is_empty then
							from
								j := 1
							until
								j > state.ce.seq_lengths [value].to_integer_32 or j > 10 -- TODO Li: this is a hack to prevent large sequence
							loop
								if state.ce.seq_item.has (value + ", " + j.out) then
									item_value := state.ce.seq_item [value + ", " + j.out]
									values.extend (valuation (seq_name + " [" + j.out + "]", item_value))
								end
								j := j + 1
							end
						else
							values.extend ("(No sequence for array " + seq_name + " found in the counterexample.)")
						end
					end
				end
				i := i + 1
			end

			if values.is_empty then
				Result := "<No values available>"
			else
				Result := ""
				across values as val loop
					if @val.cursor_index /= 1 then
						Result := Result + ", "
					end
					Result := Result + val
				end
				Result := Result + "."
			end
		end

	valuation (a_var: STRING; a_value: STRING): STRING
			-- String of a valuation
		local
			value: STRING
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

	safe_var (a_var: STRING): STRING
			-- Remove "Current" in `a_var' if any
		do
			if a_var.has_substring ("Current.") then
				Result := a_var.split ('.').last
			else
				Result := a_var
			end
		end

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
