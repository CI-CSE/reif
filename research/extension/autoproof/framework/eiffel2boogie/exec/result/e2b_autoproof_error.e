note
	description: "A result for a failed verification."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_AUTOPROOF_ERROR

inherit

	E2B_VERIFICATION_RESULT
		redefine
			is_equal
		end

	E2B_SHARED_CONTEXT
		redefine
			is_equal
		end

feature -- Access

	type: STRING
			-- Type of error.

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this result.
		do
			a_formatter.add (internal_message)
		end

	context_line_number: INTEGER
			-- Line number of error (if any)

	is_warning: BOOLEAN
			-- Should verification proceed if this error occurs?

feature -- Element change

	set_type (a_string: STRING)
			-- Set `type' to `a_type'.
		do
			type := a_string
		end

	set_message (a_string: READABLE_STRING_32)
			-- Set `single_line_message' to `a_string'.
		do
			internal_message := a_string
		end

	set_line_number (a_value: INTEGER)
			-- Set `context_line_number' to `a_value'.
		do
			context_line_number := a_value
		end

	set_warning (a_flag: BOOLEAN)
			-- Set `is_warning' to `a_flag'
		do
			is_warning := a_flag
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Does `a_other' represent the same error in the same context?
		do
			Result := type ~ a_other.type and
				helper.is_same_class (context_class, a_other.context_class) and
				helper.is_same_feature (context_feature, a_other.context_feature) and
				context_line_number = a_other.context_line_number and
				internal_message ~ a_other.internal_message
		end

feature {E2B_AUTOPROOF_ERROR} -- Implementation

	internal_message: READABLE_STRING_32
			-- Message for this error.

;note
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
