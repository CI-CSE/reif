note
	description: "This class extracts heap states from counterexamples."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_CE_TRACE_OF_ROUTINE

inherit

	E2B_SHARED_CONTEXT
		redefine
			out
		end

create
	make

feature {NONE} -- Initialize

	make (a_target_feature: detachable FEATURE_I; a_target_class: detachable CLASS_C; a_ce: E2B_BOOGIE_COUNTEREXAMPLE)
		local
			state: E2B_CE_STATE_OF_ROUTINE
		do
			-- print ("extract counterexample trace for: " + a_target_feature.feature_name_32.to_string_8 + " " + a_target_class.name + "%N")
			start_timer

			create states.make (0)

			-- loop over heap values; generate a state for each heap value
			across a_ce.heap_values as v loop
				create state.make (a_target_feature, a_target_class, a_ce, v)
				states.extend (state)
			end
			-- print ("etract trace time: " + current_timer.out + "%N")
			stop_timer
		end

feature -- Status report

	states: ARRAYED_LIST [E2B_CE_STATE_OF_ROUTINE]

	out: STRING
		-- String representation of a ce trace
	do
		Result := ""

		across states as s loop
			Result := Result + s.out
			Result := Result + "STATE_END%N"
		end
		Result := Result + "TRACE_END%N"
	end

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

