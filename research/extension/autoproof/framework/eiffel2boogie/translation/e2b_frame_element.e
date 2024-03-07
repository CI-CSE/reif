note
	description: "An entry in a frame description; denotes a set of objects restricted to some fields."
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_FRAME_ELEMENT

create
	make

feature {NONE} -- Initialization

	make (a_objects: LIST [IV_EXPRESSION]; a_fields: LIST [IV_ENTITY]; a_type: E2B_TYPE_A; a_origin: E2B_CLASS_C)
			-- Create an entry in a frame description that denotes a set of objects `a_objects' of type `a_type' restricted to fields `a_fields',
			-- where the frame clause is written in `a_origin'.
		require
			objects_exists: attached a_objects
			fields_exists: attached a_fields
			type_exists: attached a_type
			origin_exists: attached a_origin
		do
			objects := a_objects
			fields := a_fields
			type := a_type
			origin := a_origin
		ensure
			objects_set: objects = a_objects
			fields_set: fields = a_fields
			type_set: type = a_type
			origin_set: origin = a_origin
		end

feature -- Access

	objects: LIST [IV_EXPRESSION]
			-- Object descriptions.

	fields: LIST [IV_ENTITY]
			-- Fields to which the objects are restricted.

	type: E2B_TYPE_A
			-- Eiffel type of each of the `objects'.

	origin: E2B_CLASS_C
			-- Class where the frame clause was written in.

invariant
	objects_exists: attached objects
	fields_exists: attached fields
	type_exists: attached type
	origin_exists: attached origin

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
