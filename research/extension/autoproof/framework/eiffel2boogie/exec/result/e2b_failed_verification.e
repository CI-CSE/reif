note
	description: "Result of a failed verification."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FAILED_VERIFICATION

inherit

	E2B_VERIFICATION_RESULT
	SHARED_LOCALE
	FORMATTED_MESSAGE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize.
		do
			create errors.make
		end

feature -- Access

	errors: LINKED_LIST [E2B_VERIFICATION_ERROR]
			-- List of verification errors.

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- <Precursor>
		local
			n: like errors.count
		do
			if errors.is_empty then
				a_formatter.add ("(no message found)")
			else
				errors.first.single_line_message (a_formatter)
				n := errors.count
				if n > 1 then
					format_elements
						(a_formatter,
						locale.plural_translation_in_context (" (+1 more error)", " (+{1} more errors)", "tool.autoproof.error", n - 1),
						<<agent {TEXT_FORMATTER}.add ((n - 1).out)>>)
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
