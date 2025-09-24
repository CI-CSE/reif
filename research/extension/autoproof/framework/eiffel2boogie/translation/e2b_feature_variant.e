note
	description: "[
		Variant of a feature for specific usage like creation, qualified or unqualified call
	]"

once class E2B_FEATURE_VARIANT

create
	creator,
	unqualified,
	qualified

feature {NONE} -- Creation
	creator
		once
			type := -1
		ensure
			is_creator
		end

	unqualified
		once
			type := 0
		ensure
			is_unqualified
		end

	qualified
		once
			type := 1
		ensure
			is_qualified
		end

	type: INTEGER

feature
	is_creator: BOOLEAN
			-- Is the feature used as creation procedure (like `create x.f`)?
		do
			Result := type = -1
		end

	is_unqualified: BOOLEAN
			-- Is the feature used for unqualified calls (like `f`)?
		do
			Result := type = 0
		end

	is_qualified: BOOLEAN
			-- Is the feature used for qualified calls (like `x.f`)?
		do
			Result := type = 1
		end

invariant
	type_range: -1 <= type and type <= 1
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
