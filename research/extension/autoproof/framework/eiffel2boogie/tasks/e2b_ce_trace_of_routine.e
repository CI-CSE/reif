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
			name_val, val_name: HASH_TABLE [ARRAYED_SET [STRING], STRING]
		do
			create name_val.make (0)
			create val_name.make (0)

			across ce.initial_name_to_raw as raw_value loop
				if not @raw_value.key.has_substring (".")
					and then not @raw_value.key.has_substring ("@") then
					extend_by_key (name_val, raw_value, @raw_value.key)
					extend_by_key (val_name, @raw_value.key, raw_value)
				end

			end
			across states as s loop
				across s.locals as loc_value loop
					extend_by_key (name_val, loc_value, @loc_value.key)
					extend_by_key (val_name, @loc_value.key, loc_value)
				end
			end

			create translation_map.make (0)
			across val_name as loc_names loop
				if loc_names.count = 1 and then name_val [loc_names.first].count = 1 then
					translation_map [@ loc_names.key] := loc_names.first
				end
			end

				-- raw value of Void is stored in the ce mapping
			translation_map [ce.initial_name_to_raw ["Void"]] := "Void"
			-- always translate Current as Current
			if name_val ["Current"].count = 1 then
				translation_map [name_val ["Current"].first] := "Current"
			end
		end

	extend_by_key (a: HASH_TABLE [ARRAYED_SET [STRING], STRING]; v, k: STRING)
		do
			if not a.has (k) then
				a [k] := create {ARRAYED_SET [STRING]}.make (1)
				a [k].compare_objects
			end
			a [k].extend (v)
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

	translate_record_field_name (obj_id, record_field_id: STRING): STRING
		local
			cls, fid: STRING
		do
			cls := ce.apply_function ("type_of", create {ARRAYED_LIST [STRING]}.make_from_array (<<obj_id>>))
			fid := ce.apply_function ("FieldId", create {ARRAYED_LIST [STRING]}.make_from_array (<<record_field_id, cls>>))
			if fid /= Void and then fid.starts_with ("(- ") then
				-- Negative field ids are builtin and unique,
				-- so take first name which has this raw value
				across ce.initial_name_to_raw as raw loop
					if raw ~ record_field_id then
						Result := @ raw.key
					end
				end
			end
			if Result = Void then
				Result := obj_id + "_" + record_field_id
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

