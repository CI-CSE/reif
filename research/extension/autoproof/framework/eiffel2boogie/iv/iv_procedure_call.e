note
	date: "$Date: 2019-09-07 16:30:37 +0800 (Sat, 07 Sep 2019) $"
	revision: "$Revision: 103489 $"

class
	IV_PROCEDURE_CALL

inherit

	IV_STATEMENT

inherit {NONE}

	IV_HELPER

create
	make

feature {NONE} -- Initialization

	make (a_name: READABLE_STRING_8)
			-- Initialize call to procedure `a_name'.
		do
			name := a_name.twin
			create arguments.make
		ensure
			name_set: name ~ a_name
		end

feature -- Access

	name: READABLE_STRING_8
			-- Name of called procedure.

	arguments: LINKED_LIST [IV_EXPRESSION]
			-- Arguments of procedure call.

	target: detachable IV_EXPRESSION
			-- Target that receives result of procedure call (if any).

	is_recursive: BOOLEAN
			-- Is the current call a recursive call?

feature -- Element change

	add_argument (a_argument: IV_EXPRESSION)
			-- Add argument `a_argument'.
		require
			a_argument_attached: attached a_argument
		do
			arguments.extend (a_argument)
		end

	set_target (a_target: like target)
			-- Set `target' to `a_target'.
		do
			target := a_target
		ensure
			target_set: target = a_target
		end

	set_is_recursive (a_value: like is_recursive)
			-- Set `is_recursive' to `a_value'.
		do
			is_recursive := a_value
		ensure
			target_set: is_recursive = a_value
		end

feature -- Visitor

	process (a_visitor: IV_STATEMENT_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_procedure_call (Current)
		end

invariant
	name_attached: attached name
	name_valid: is_valid_name (name)
	arguments_attached: attached arguments

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
