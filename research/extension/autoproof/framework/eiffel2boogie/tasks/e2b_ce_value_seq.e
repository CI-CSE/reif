note
	description: "Seq represented in a counterexample"

class
	E2B_CE_VALUE_SEQ

inherit
	E2B_CE_VALUE

create
	make, make_copied

feature {NONE}
	make
		do
			reset
		end

	make_copied (other: E2B_CE_VALUE_SEQ)
		do
			length := other.length
		end

	reset
		do
			length := -1
		end

feature

	update (id: STRING; ce: E2B_BOOGIE_COUNTEREXAMPLE)
		local
			s: STRING
		do
			reset
			if ce.functions.has ("Seq#Length") then
				s := ce.apply_function ("Seq#Length", create {ARRAYED_LIST [STRING]}.make_from_array (<< id >>))
				if s /= Void then
					length := s.to_integer
				else
					length := -1
				end
			end
			if attached find_args (ce, "Seq#Constant", id) as args then
				constant := [args [1], args [2]]
			end
			if attached find_args (ce, "Seq#Singleton", id) as args then
				singleton := args[1]
			end
			if attached find_args (ce, "Seq#Extended", id) as args then
				extended := [args [1], args [2]]
			end
			if ce.functions.has ("Seq#Item") then
				create items.make (0)
				across ce.functions ["Seq#Item"] as case loop
					if case.args /= Void and then case.args [1] ~ id then
						items [case.args [2]] := case.res
					end
				end
			end
		end

	find_args (ce: E2B_BOOGIE_COUNTEREXAMPLE; function, res: STRING):
		detachable LIST [STRING]
		do
			if ce.functions.has (function) then
				across ce.functions [function] as case until Result /= Void loop
					if case.args /= Void and then case.res ~ res then
						Result := case.args
					end
				end
			end
		end

	constant: detachable TUPLE [val: STRING; n: STRING]
			-- This is a sequence of `val` repeated `n` times

	singleton: detachable STRING
			-- This is a singleton sequence of `singleton`

	length: INTEGER
			-- Seq#Length or `-1` if unknown

	extended: detachable TUPLE [a, b: STRING]
			-- This is a sequence `a` extended with `b`

	items: detachable HASH_TABLE [STRING, STRING]
			-- Index to item

	copied: E2B_CE_VALUE_SEQ
		do
			create Result.make_copied (Current)
		end

	multi_line_message_lines (trace: E2B_CE_TRACE_OF_ROUTINE): ARRAYED_LIST [STRING]
		do
			create Result.make (0)
			if length >= 0 then
				Result.extend ("Seq#Length = " + trace.translate_raw (length.out))
			end
			if attached constant as c then
				Result.extend ("Is Seq#Constant("
					+ trace.translate_raw (constant.val) + ", "
					+ trace.translate_raw (constant.n) + ")")
			end
			if attached singleton as s then
				Result.extend ("Is Seq#Singleton("
					+ trace.translate_raw (singleton) + ")")
			end
			if attached extended as e then
				Result.extend ("Is Seq#Extended("
					+ trace.translate_raw (e.a) + ", "
					+ trace.translate_raw (e.b) + ")")
			end
			if attached items as l_items then
				across l_items as value loop
					Result.extend ("Seq#Item [" + trace.translate_raw (@value.key) + "] = "
						+ trace.translate_raw (value))
				end
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
