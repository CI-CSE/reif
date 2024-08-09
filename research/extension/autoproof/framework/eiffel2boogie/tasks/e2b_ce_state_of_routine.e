note
	description: "One state from the counterexample trace. See E2B_CE_TRACE_OF_ROUTINE."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_CE_STATE_OF_ROUTINE

inherit
	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialize

	make (a_ce: E2B_BOOGIE_COUNTEREXAMPLE; a_name: READABLE_STRING_32;
		a_state_values: STRING_TABLE [READABLE_STRING_32];
		a_prev_state: detachable E2B_CE_STATE_OF_ROUTINE)
			-- `a_name` - name of the state
			-- `a_values` - own values of the state
			-- `a_prev_state` - the previous state or Void for first state
		require
			a_name /= Void
			a_ce /= Void
			a_state_values /= Void
		do
			name := a_name
			ce := a_ce

			if a_prev_state /= Void then
				create values.make (a_prev_state.values.count)
				across a_prev_state.values as val loop
					values [@ val.key] := val.copied
				end

				create locals.make (a_prev_state.locals.count)
				locals.copy (a_prev_state.locals)
			else
				create values.make (0)
				create locals.make (0)
			end

			across a_state_values as loc loop
				locals [@ loc.key] := loc
			end

			update_heap_records (a_state_values)
			update_seqs
			update_sets
		end

	update_heap_records (a_state_values: STRING_TABLE [READABLE_STRING_32])
		local
			heap_id: READABLE_STRING_32
			record: E2B_CE_VALUE_RECORD
		do
			heap_id := a_state_values ["Heap"]
			across ce.functions ["MapType0Select"] as case loop
				if case.args /= Void and then case.args [1] ~ heap_id then
					if not values.has (case.args [2]) then
						create record.make_empty
						values [case.args [2]] := record
					else
						check attached {E2B_CE_VALUE_RECORD} values [case.args [2]] as r then
							record := r
						end
					end
					record.put (case.res, case.args [3])
				end
			end
		end

	update_sets
		local
			set: E2B_CE_VALUE_SET
			set_id: READABLE_STRING_32
		do
			if ce.functions.has ("Set#Empty") then
				across ce.functions ["Set#Empty"] as case loop
					set_id := case.res
					if not values.has (set_id) then
						create set.make
						values [set_id] := set
					else
						check attached {E2B_CE_VALUE_SET} values [set_id] as existing_set then
							set := existing_set
						end
					end
					set.update_from_set_empty (case, ce)
				end
			end
		end

	update_seqs
		local
			sequence: E2B_CE_VALUE_SEQ
			seq_id: READABLE_STRING_32
		do
			if ce.functions.has ("SeqType") then
				across ce.functions ["SeqType"] as seq_type loop
					across ce.functions ["type"] as type_case loop
						if type_case.res ~ seq_type.res then
							seq_id := type_case.args.first
							if not values.has (seq_id) then
								create sequence.make
								values [seq_id] := sequence
							else
								check attached {E2B_CE_VALUE_SEQ} values[seq_id] as ss then
									sequence := ss
								end
							end
							sequence.update (seq_id, ce)
						end
					end
				end
			end

		end

	is_abstract_value (s: STRING): BOOLEAN
		do
			Result := s.starts_with ("T@U!val!")
		end

feature -- Data

	ce: E2B_BOOGIE_COUNTEREXAMPLE

	name: READABLE_STRING_32
			-- Name of the state

	values: STRING_TABLE [E2B_CE_VALUE]
			-- Mapping from local name or abstract id to value

	locals: STRING_TABLE [READABLE_STRING_32]

feature -- State access

	is_aliased_with_existed_object (object_name: STRING): BOOLEAN
			-- Is this objected aliased with other object?
		do
--			Result := ce.raw_to_name [ce.name_to_raw [object_name]].count > 1 -- TODO
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

