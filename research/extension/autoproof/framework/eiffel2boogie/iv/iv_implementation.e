note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	IV_IMPLEMENTATION

inherit

	IV_DECLARATION

create
	make

feature {NONE} -- Initialization

	make (a_procedure: IV_PROCEDURE)
			-- Initialize implementation of procedure `a_procedure'.
		require
			a_procedure_attached: attached a_procedure
		do
			procedure := a_procedure
			create locals.make
			create body.make_name ("entry")
		ensure
			procedure_set: procedure = a_procedure
		end

feature -- Access

	procedure: IV_PROCEDURE
			-- Procedure that this implementation is about.

	locals: LINKED_LIST [IV_ENTITY_DECLARATION]
			-- Local variables.

	body: IV_BLOCK
			-- List of statements.

	has_conditional: BOOLEAN
			-- Does the implementation contain any conditional statement?

feature -- Element change

	add_local (a_name: READABLE_STRING_8; a_type: IV_TYPE)
			-- Add local variable with name `a_name' and type `a_type'.
		do
			locals.extend (create {IV_ENTITY_DECLARATION}.make (a_name, a_type))
		ensure
			local_added: locals.last.name ~ a_name
			local_added: locals.last.type = a_type
		end

	add_local_with_property (a_name: READABLE_STRING_8; a_type: IV_TYPE; a_prop: IV_EXPRESSION)
			-- Add local variable with name `a_name' and type `a_type' and where-property `a_prop'.
		local
			l_decl: IV_ENTITY_DECLARATION
		do
			create l_decl.make (a_name, a_type)
			l_decl.set_property (a_prop)
			locals.extend (l_decl)
		ensure
			local_added: locals.last.name ~ a_name
			local_added: locals.last.type = a_type
		end

	set_has_conditional (a_value: BOOLEAN)
		-- Set the `has_conditional' to `a_value'
	do
		has_conditional := a_value
	end

feature -- Visitor

	process (a_visitor: IV_UNIVERSE_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_implementation (Current)
		end

invariant
	locals_attached: attached locals
	body_attached: attached body

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
