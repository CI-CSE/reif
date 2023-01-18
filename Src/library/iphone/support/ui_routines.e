note
	description: "Facilities to get an Eiffel object from an object C UIView object."
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	UI_ROUTINES

inherit
	ANY

	IDENTIFIED_ROUTINES
		export
			{NONE} all
		end

feature -- Access

	eiffel_object_from_c (a_obj: POINTER): detachable UI_VIEW
		require
			a_obj_not_null: a_obj /= default_pointer
		local
			l_id: INTEGER
		do
			l_id := {UI_VIEW_API}.eiffel_object_id (a_obj)
			if l_id >= 0 and then attached {UI_VIEW} eif_id_object (l_id) as l_view then
				Result := l_view
			end
		end

note
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
