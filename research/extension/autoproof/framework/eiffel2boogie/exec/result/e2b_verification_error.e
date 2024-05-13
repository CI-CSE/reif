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

	ce_init_state: detachable E2B_CE_STATE_OF_ROUTINE
			-- Initial state extracted from the corresponding counterexample

feature -- Display

	set_ce_init_state (a_ce_init_state: E2B_CE_STATE_OF_ROUTINE)
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

	ce_message_string (state: E2B_CE_STATE_OF_ROUTINE): STRING
			-- Message for displaying all tuples of values and variables in the counterexample
		require
			state /= Void
		local
			s: STRING

			aliases: STRING
			values: STRING

		do
			Result := ""

			aliases := ""
			across state.alias_groups as g loop
				s := ""
				across g as o loop
					if not @ o.is_first then
						s := s + " = "
					end
					s := s + o
				end

				if not s.is_empty then
					if not aliases.is_empty then
						aliases := aliases + " ; "
					end
					aliases := aliases + s
				end
			end
			if not aliases.is_empty then
				Result := "Aliases: " + aliases
			end

			values := ""
			across state.initial_values_by_heap as h loop
				s := ""
				across h.values.current_keys as k loop
					if not s.is_empty then
						s := s + "%N%T"
					end
					s := s + k + " = " + h.values [k]
				end
				if not s.is_empty then
					if not values.is_empty then
						values := values + "%N"
					end
					values := values + h.heap + " => %N%T" + s
				end
			end
			if not values.is_empty then
				if not Result.is_empty then
					Result := Result + "%N"
				end
				Result := Result + values
			end

			if Result.is_empty then
				Result := "<No counterexample details available>"
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
