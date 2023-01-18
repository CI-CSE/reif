note
	description: "[
		External iteration cursor used by `across...loop...end' 
		using `key' and `item'.
		]"
	library: "EiffelBase: Library of reusable components for Eiffel."
	status: "See notice at end of class."
	legal: "See notice at end of class."
	copyright: "Copyright (c) 1984-2011, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	date: "$Date: 2020-01-08 18:24:11 +0800 (周三, 08 1月 2020) $"
	revision: "$Revision: 103831 $"

deferred class
	TABLE_ITERATION_CURSOR [G, K]

inherit
	ITERATION_CURSOR [G]
		export {ANY} all end

feature -- Access

	key: K
			-- Key at current cursor position
		require
			valid_position: not after
		deferred
		end

note
	copyright: "Copyright (c) 1984-2012, Eiffel Software and others"
	license:   "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
