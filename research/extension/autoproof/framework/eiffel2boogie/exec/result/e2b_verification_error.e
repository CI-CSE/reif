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

	trace: detachable E2B_CE_TRACE_OF_ROUTINE
			-- Counterexample trace

feature -- Display

	set_trace (a_trace: E2B_CE_TRACE_OF_ROUTINE)
			-- Set `trace' to `a_trace'.
		do
			trace := a_trace
		end

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this error.
		deferred
		end

	multi_line_message (a_formatter: TEXT_FORMATTER)
			-- Multi line description of this error.
		do
			single_line_message (a_formatter)
			if trace /= Void then
				a_formatter.add_new_line
				a_formatter.process_basic_text (counterexample_message_string)
			end
		end

	counterexample_message_string: detachable READABLE_STRING_32
			-- Multi-line counterexample text
		do
			if attached trace as t then
				Result := ce_message_string
			end
		end

feature {NONE} -- Counterexample text generation

	ce_message_string: READABLE_STRING_32
			-- Message for displaying all tuples of values and variables in the counterexample
		require
			trace /= Void
		local
			values, obj_values: READABLE_STRING_32
		do
			Result := ""

			across trace.states as state loop
				if @ state.cursor_index > 1 then -- skip <initial> state
					if not Result.is_empty then
						Result := Result + "%N"
					end
					Result := Result + "State: " + state.name + " =>"
					values := ""
					across state.locals as val loop
						if
							not is_ignored_variable (@ val.key)
								-- don't print "x = x"
							and then @ val.key /~ trace.translate_raw (val)
						then
							if
								attached state.values [val] as inline_obj
								and then attached inline_obj.inline_text (trace) as inline_text
							then
								values := values + "%N%T" + @val.key + " = " + inline_text
							else
								values := values + "%N%T" + @ val.key + " = " + trace.translate_raw (val)
							end
						end
					end

					across state.values.current_keys as obj loop
						-- Don't show fields of Void
						if
							not is_ignored_object (trace.translate_raw (obj))
							and state.values [obj].inline_text (trace) = Void
						then
							obj_values := ""
							if attached {E2B_CE_VALUE_RECORD} state.values [obj] as o then
								across o.values as val loop
									if not is_ignored_object_field (
										trace.translate_record_field_name (obj, @ val.key)) then
										obj_values := obj_values + "%N%T%T"
											+ trace.translate_record_field_name (obj, @ val.key)
											+ " = "
											+ if
													attached state.values [val] as inline_obj
													and then attached inline_obj.inline_text (trace) as inline_text
												then
													inline_text
												else
													trace.translate_raw (val)
												end
									end
								end
							else
								across state.values [obj].multi_line_message_lines (trace) as line loop
									obj_values := obj_values + "%N%T%T" + line
								end
							end
							if not obj_values.is_empty then
									values := values + "%N%T" + trace.translate_raw (obj)
										+ " =>" + obj_values
								end
						end
					end

					if not values.is_empty then
						Result := Result + values
					end
				end
			end

			if Result.is_empty then
				Result := "<No counterexample details available>"
			end
		end

	is_ignored_variable (s: READABLE_STRING_32): BOOLEAN
		do
			Result := s ~ "Current" or s ~ "Heap" or s.starts_with ("temp_")
		end

	is_ignored_object (s: READABLE_STRING_32): BOOLEAN
		local
			vals: ARRAY [READABLE_STRING_32]
		do
			vals := << "Void", "boxed_true", "boxed_false" >>
			vals.compare_objects
			Result := vals.has (s)
		end

	is_ignored_object_field (f: READABLE_STRING_32): BOOLEAN
		do
			Result := f ~ "allocated"
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
			Result := a_var + " = " + value
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
