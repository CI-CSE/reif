note
	description: "Wrapper for INVARIANT_FEAT_I to add convinience features."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_INVARIANT_FEAT_I

inherit
	E2B_FEATURE_I
		redefine
			make
		end

create
	make

feature -- Creator
	make (a_feature: INVARIANT_FEAT_I)
		require else
			a_feature /= Void
		do
			c_feature := a_feature
		ensure then
			c_feature = a_feature
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
