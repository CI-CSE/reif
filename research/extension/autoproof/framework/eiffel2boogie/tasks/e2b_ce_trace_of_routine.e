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
			name_val, val_name: STRING_TABLE [ARRAYED_SET [READABLE_STRING_32]]
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

	extend_by_key (a: STRING_TABLE [ARRAYED_SET [READABLE_STRING_32]]; v, k: READABLE_STRING_32)
		do
			if not a.has (k) then
				a [k] := create {ARRAYED_SET [READABLE_STRING_32]}.make (1)
				a [k].compare_objects
			end
			a [k].extend (v)
		end

	is_ignored_initial_name (s: STRING): BOOLEAN
		do
			Result := s.has_substring ("@@")
		end

	translation_map: STRING_TABLE [READABLE_STRING_32]
			-- See `fill_translation_map`

	is_abstract_value (s: READABLE_STRING_32): BOOLEAN
		do
			Result := s.starts_with ("T@U!val!")
		end

feature -- Status report

	translate_raw (raw: READABLE_STRING_32): READABLE_STRING_32
		do
			if translation_map.has (raw) then
				Result := translation_map [raw]
			elseif is_abstract_value (raw) then
				Result := {STRING_32} "$" + raw.split ('!').last
			else
				Result := raw
			end
		end

	translate_record_field_name (obj_id, record_field_id: READABLE_STRING_32): READABLE_STRING_32
		local
			cls, fid: READABLE_STRING_32
			id: INTEGER
		do
			cls := ce.apply_function ("type_of", create {ARRAYED_LIST [READABLE_STRING_32]}
				.make_from_array (<<obj_id>>))
			if cls /= Void then
				fid := ce
					.apply_function ("FieldId", create {ARRAYED_LIST [READABLE_STRING_32]}
						.make_from_array (<<record_field_id, cls>>))
			end

			if fid = Void then
					-- We could not find the exact (type, field) pair,
					-- so let's try to find this field in any other type
				across ce.functions ["FieldId"] as case until fid /= Void loop
					if case.args [1].same_string (record_field_id) then
						fid := case.res
						cls := case.args [2]
					end
				end
			end

			if fid /= Void then
				if fid.starts_with ("(- ") then
						-- this is a negative numebr, so
						-- strip "(- " from the beginning and ")" from the end
						-- then take the opposite (unary minus)
					id := fid.substring (3, fid.count - 1).to_integer.opposite
				else
					id := fid.to_integer
				end

				across boogie_universe.declarations as d until Result /= Void loop
					if attached {IV_FIELD_ID_AXIOM} d as axiom then
						if axiom.id = id
							and name_translator.boogie_name_for_type (axiom.context_type).to_string_32 ~ translate_raw (cls) then
							Result := axiom.field_name.to_string_32
						end
					end
				end
			end

			if Result = Void then
					-- Unknown field id, fallback to just the raw ids
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

