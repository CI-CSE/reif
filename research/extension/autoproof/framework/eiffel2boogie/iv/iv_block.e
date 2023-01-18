note
	date: "$Date$"
	revision: "$Revision$"

class
	IV_BLOCK

inherit

	IV_STATEMENT

inherit {NONE}

	IV_HELPER

create
	make,
	make_name

feature {NONE} -- Initialization

	make
			-- Initialize empty block.
		do
			create statements.make
			name := ""
		end

	make_name (a_name: READABLE_STRING_8)
			-- Initialize block with name `a_name'.
		do
			create statements.make
			name := a_name.twin
		ensure
			name_set: name ~ a_name
		end

feature -- Status report

	is_empty: BOOLEAN
			-- Is this block empty?
		do
			Result := statements.is_empty
		end

	is_conditional_leaf: BOOLEAN
	    	-- Is this block a conditional leaf block
	    do
	    	Result := True
	    	across statements as s loop
	    		if attached s.origin_information as oi and then oi.text_of_line.has_substring ("if ") then
					Result := False
	    		end
	    	end
	    end

feature -- Access

	name: READABLE_STRING_8
			-- A unique name for this block.

	statements: LINKED_LIST [IV_STATEMENT]
			-- List of statements in this block.

feature -- Element change

	add_statement (a_statement: IV_STATEMENT)
			-- Add `a_statement' to `statements'.
		require
			a_statement_attached: attached a_statement
		do
			statements.extend (a_statement)
		end

	add_statement_before_last (a_statement:IV_STATEMENT)
			-- Add `a_statement' to `statements', but position it before the last item in `statements'
		require
			a_statement_attached: attached a_statement
			statements_not_empty: not statements.is_empty
		do
			statements.finish
			statements.put_left (a_statement)
		ensure
			last_not_removed: statements.has ((old statements).last)
			last_not_changed: statements.last = (old statements).last
			a_statment_added: statements.has (a_statement)
		end

	set_name (a_name: STRING)
			-- Set `name' to `a_name'.
		require
			a_name_attached: attached a_name
		do
			name := a_name.twin
		ensure
			name_set: name ~ a_name
		end

	set_unique_name
			-- Generate a unique name for a block.
		do
			shared_number.put (shared_number.item + 1)
			name := "block" + shared_number.item.out
		end

feature -- Visitor

	process (a_visitor: IV_STATEMENT_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_block (Current)
		end

feature {NONE} -- Initialization

	shared_number: CELL [INTEGER]
			-- Number shared for all blocks.
		once
			create Result.put (0)
		end

invariant
	statements_attached: attached statements
	name_attached: attached name
	name_valid: is_valid_name (name) or name.is_empty

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
