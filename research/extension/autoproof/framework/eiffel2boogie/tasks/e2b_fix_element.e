note
	description: "Summary description for {E2B_FIX_ELEMENT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FIX_ELEMENT

create make

feature -- Initialize

    make (a_var_name: READABLE_STRING_GENERAL)
        -- Initialize a fix element
    require
    	a_var_name.is_string_8
    do
        var_name := a_var_name.to_string_8
    end

    set_max (a_max: INTEGER)
        -- Set `max' to `a_max'
    do
    	max := a_max
    end

    set_min (a_min: INTEGER)
        -- Set `min' to `a_min'
    do
    	min := a_min
    end

feature

    var_name: STRING
       -- Name of variable

    max: INTEGER
       -- Maximum value in the counterexamples

    min: INTEGER
       -- Minimum value in the counterexamples

    is_constant: BOOLEAN
       -- Is the value of variable a constant in the counterexamples
     do
        Result := max = min
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
