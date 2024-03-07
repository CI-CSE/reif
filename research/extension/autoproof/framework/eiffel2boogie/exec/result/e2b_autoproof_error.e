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

feature -- Add error to shared context

	add_unsupported_error (a_class_or_feature: ANY; a_message: READABLE_STRING_32; a_line_number: INTEGER)
			-- Add AutoProof error about unsupported construct concerning `a_class_or_feature' with message `a_message'.
			-- Verification will not proceed.
		do
			put_error (a_class_or_feature, a_message, a_line_number, False, "Unsupported")
		end

	add_semantic_error (a_class_or_feature: ANY; a_message: READABLE_STRING_32; a_line_number: INTEGER)
			-- Add AutoProof validity error concerning `a_class_or_feature' with message `a_message'.
			-- Verification will not proceed.
		do
			put_error (a_class_or_feature, a_message, a_line_number, False, "Validity")
		end

	add_semantic_warning (a_class_or_feature: ANY; a_message: READABLE_STRING_32; a_line_number: INTEGER)
			-- Add AutoProof validity warning concerning `a_class_or_feature' with message `a_message'.
			-- Verification will proceed.
		do
			put_error (a_class_or_feature, a_message, a_line_number, True, "Validity")
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Does `a_other' represent the same error in the same context?
		do
			Result := type ~ a_other.type and
				context_class.is_same_class (a_other.context_class) and
				context_feature.is_same_feature (a_other.context_feature) and
				context_line_number = a_other.context_line_number and
				internal_message ~ a_other.internal_message
		end

feature {E2B_AUTOPROOF_ERROR} -- Implementation

	internal_message: READABLE_STRING_32
			-- Message for this error.

	put_error (a_class_or_feature: ANY; a_message: READABLE_STRING_32; a_line_number: INTEGER; a_is_warning: BOOLEAN; a_error_type: STRING_8)
		require
			class_or_feature_or_void: a_class_or_feature = Void or else (attached {E2B_CLASS_C} a_class_or_feature or attached {E2B_FEATURE_I} a_class_or_feature)
			message_set: a_message /= Void and then not a_message.is_empty
		local
			l_error: E2B_AUTOPROOF_ERROR
		do
			create l_error
			l_error.set_type (a_error_type)
			l_error.set_message (a_message)
			if attached {E2B_FEATURE_I} a_class_or_feature as x then
				l_error.set_feature (x)
			elseif attached {E2B_CLASS_C} a_class_or_feature as x then
				l_error.set_class (x)
			end
			l_error.set_line_number (a_line_number)
			l_error.set_warning (a_is_warning)
			if not autoproof_errors.has (l_error) then
				autoproof_errors.extend (l_error)
			end
		end

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
