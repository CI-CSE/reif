note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	IV_ASSERTION

feature {NONE} -- Initialization

	make (a_expression: like expression)
			-- Initialize axiom with expression `a_expression'.
		require
			a_expression_attached: attached a_expression
			boolean_expression: a_expression.type.is_boolean
		do
			expression := a_expression
		ensure
			expression_set: expression = a_expression
		end

feature -- Access

	expression: IV_EXPRESSION
			-- Axiom expression.

	attribute_string: detachable STRING
			-- Attribute string.

feature -- Element change

	set_attribute_string (a_string: STRING)
			-- Set `attribute_string' to `a_string'.
		do
			attribute_string := a_string
		ensure
			attribute_string_set: attribute_string = a_string
		end

invariant
	expression_attached: attached expression
	boolean_expression: expression.type.is_boolean

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
