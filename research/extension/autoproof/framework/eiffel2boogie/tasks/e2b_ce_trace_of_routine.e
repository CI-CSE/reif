note
	description: "Counterexample trace "
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

	make (a_ce: E2B_BOOGIE_COUNTEREXAMPLE)
		require
			a_ce /= Void
		local
			prev_state, state: E2B_CE_STATE_OF_ROUTINE
		do
			start_timer

			ce := a_ce

			create states.make (0)

			across ce.states as s loop
				create state.make (ce, s.name, s.values, prev_state)
				prev_state := state
				states.extend (state)
			end

			fill_translation_map

			stop_timer
		end

	ce: E2B_BOOGIE_COUNTEREXAMPLE

	fill_translation_map
		local
			usages: HASH_TABLE [ARRAYED_SET [STRING], STRING]
		do
			create translation_map.make (0)
			create usages.make (0)

			across ce.initial_name_to_raw as raw loop
				if not is_ignored_initial_name (@ raw.key) then
					if not usages.has (@ raw.key) then
						usages [@ raw.key] := create {ARRAYED_SET [STRING]}.make (1)
						usages [@ raw.key].compare_objects
					end
					usages [@ raw.key].extend (raw)
				end
			end

			across states as state loop
				across state.values [Void] as raw loop
					if not usages.has (@ raw.key) then
						usages [@ raw.key] := create {ARRAYED_SET [STRING]}.make (1)
						usages [@ raw.key].compare_objects
					end
					-- Store all different values of name (@ val.key)
					usages [@ raw.key].extend (raw)
				end
			end

			-- Find constant values
			across usages as raws loop
				if raws.count = 1 and then is_abstract_value (raws.first) then
					-- @ vals.key had only one value in the whole trace
					-- so we can use key as the name of the abstract value
					translation_map [raws.first] := @ raws.key
				end
			end

			-- Remove aliased translation keys
			across translation_map.current_keys.twin as raw loop
				across
					usages as raws
				until
					not translation_map.has (raw) -- break if we removed the key
				loop
					-- skip the usage recorded in the translation_map
					if @ raws.key /~ translation_map [raw] then
						if raws.has (raw) then
							translation_map.remove (raw)
						end
					end
				end
			end

			-- Always show abstract value of Void as "Void" and Current as "Current"
			across << "Void", "Current" >> as special loop
				if usages.has (special) and then usages [special].count = 1 then
					translation_map [usages [special].first] := special
				end
			end
		end

	is_ignored_initial_name (s: STRING): BOOLEAN
		do
			Result := s.has_substring ("@@")
		end

	translation_map: HASH_TABLE [STRING, STRING]
			-- See `fill_translation_map`

	is_abstract_value (s: STRING): BOOLEAN
		do
			Result := s.starts_with ("T@U!val!")
		end

feature -- Status report

	translate_raw (raw: STRING): STRING
		do
			if translation_map.has (raw) then
				Result := translation_map [raw]
			elseif is_abstract_value (raw) then
				Result := "$" + raw.split ('!').last
			else
				Result := raw
			end
		end

	states: ARRAYED_LIST [E2B_CE_STATE_OF_ROUTINE]

	initial_state: E2B_CE_STATE_OF_ROUTINE
			-- The state at the start of the routine,
			-- after local variables are initialized to default values.
		do
			Result := states [1]
		end

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

