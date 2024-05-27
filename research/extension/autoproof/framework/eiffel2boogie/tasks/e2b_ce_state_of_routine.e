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

feature -- Initialize

	make (a_ce: E2B_BOOGIE_COUNTEREXAMPLE; a_name: STRING;
		a_state_values: HASH_TABLE [STRING, STRING];
		a_prev_state: detachable E2B_CE_STATE_OF_ROUTINE)
			-- `a_name` - name of the state
			-- `a_values` - own values of the state
			-- `a_prev_state` - the previous state or Void for first state
		require
			a_name /= Void
			a_ce /= Void
			a_state_values /= Void
		local
			heap: STRING
		do
			name := a_name
			ce := a_ce

			if a_prev_state /= Void then
				create values.make (a_prev_state.values.count)
				across a_prev_state.values.current_keys as obj loop
					across a_prev_state.values [obj] as val loop
						put_value (obj, @ val.key, val)
					end
				end
			else
				create values.make (1)
				values ["Void"] := create {HASH_TABLE [STRING, STRING]}.make (0)
			end

			across a_state_values as val loop
				put_value (Void, @ val.key, val)
			end

			heap := a_state_values ["Heap"]
			across a_ce.functions ["MapType0Select"] as case loop
				if case.args /= Void and then case.args [1] ~ heap then
					if not values.has (case.args [2]) then
						values [case.args [2]] := create {HASH_TABLE [STRING, STRING]}
							.make (0)
					end
					put_value (case.args [2], case.args [3], case.res)
				end
			end
		end

	put_value (obj: detachable STRING; key, val: STRING)
		do
			if not values.has (obj) then
				values [obj] := create {HASH_TABLE [STRING, STRING]}.make (1)
			end
			values [obj][key] := val
		end

feature -- Data

	ce: E2B_BOOGIE_COUNTEREXAMPLE

	name: STRING
			-- Name of the state

	values: HASH_TABLE [HASH_TABLE [STRING, STRING], detachable STRING]
			-- Mapping from objects (or Void for local vars/args) to fields to values

feature -- State access

	container_size_named (a_var: STRING): STRING
			-- Size of the container named `a_var'
		do
			Result := "" -- TODO: apply Seq#Length function
		end

	container_item_named (a_var: STRING; i: STRING): STRING
			-- The ith element of the container named `a_var'
		do
			Result := "" -- TODO: apply Seq#Item function
		end

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

