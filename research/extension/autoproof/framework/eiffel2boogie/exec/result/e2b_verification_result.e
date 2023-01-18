note
	description: "Individual verification result."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_VERIFICATION_RESULT

inherit

	SHARED_LOCALE

feature -- Access

	time: REAL
			-- Time used for verification in seconds.

	context_feature: detachable FEATURE_I
			-- Associated feature (if any).

	context_class: detachable CLASS_C
			-- Associated class (if any).

	verification_context: detachable STRING
			-- Additional context of verification (if any).

feature -- Element change

	set_time (a_time: like time)
			-- Set `time' to `a_time'.
		do
			time := a_time
		ensure
			time_set: time = a_time
		end

	set_feature (a_feature: FEATURE_I)
			-- Set `context_feature' to `a_feature'.
		do
			context_feature := a_feature
			context_class := a_feature.written_class
		end

	set_class (a_class: CLASS_C)
			-- Set `context_class' to `a_class'.
		do
			context_class := a_class
		end

	set_verification_context (a_context: STRING)
			-- Set `verification_context' to `a_context'.
		do
			if attached a_context then
				verification_context := a_context.twin
			else
				verification_context := Void
			end
		end

feature -- Display

	single_line_message (a_formatter: TEXT_FORMATTER)
			-- Single line description of this result.
		deferred
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
