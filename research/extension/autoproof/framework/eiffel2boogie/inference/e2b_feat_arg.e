note
	description: "Wrapper for FEAT_ARG to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FEAT_ARG

inherit
	ARRAYED_LIST [E2B_TYPE_A]
		rename
			make as old_make
		export
			{ANY} area
		end

	INTERNAL_COMPILER_STRING_EXPORTER
		undefine
			copy, is_equal
		end

create
	old_make, make

feature -- Creator
	make (a_feat: FEAT_ARG)
		require
			a_feat /= Void
		do
			c_feat := a_feat
		ensure
			c_feat = a_feat
		end

feature -- Wrapped object
	c_feat: FEAT_ARG

feature -- Wrapped features

	item_name_32 (i: INTEGER): STRING_32
		do Result := c_feat.item_name_32 (i) end

	item_name (i: INTEGER): STRING
		do Result := c_feat.item_name (i) end

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
