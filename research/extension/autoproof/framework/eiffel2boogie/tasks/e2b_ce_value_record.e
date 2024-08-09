note
	description: "Record represented in a counterexample"

class
	E2B_CE_VALUE_RECORD

inherit
	E2B_CE_VALUE

create
	make, make_empty, make_copy

feature {NONE}
	make (a_values: STRING_TABLE [READABLE_STRING_32])
		do
			create values.make (a_values.count)
			values.copy (a_values)
		end

	make_empty
		do
			create values.make (0)
		end

	make_copy (other: E2B_CE_VALUE_RECORD)
		do
			create values.make (other.values.count)
			values.copy (other.values)
		end

feature

	values: STRING_TABLE [READABLE_STRING_32]

	copied: E2B_CE_VALUE_RECORD
		do
			create Result.make_copy (Current)
		end

	put (v, k: READABLE_STRING_32)
		do
			values [k] := v
		end

feature

	multi_line_message_lines (trace: E2B_CE_TRACE_OF_ROUTINE): ARRAYED_LIST [READABLE_STRING_32]
		do
			create Result.make_from_array (<< "<Not implemented>" >>)
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
