note
	description: "Unicode characters, with comparison operations"
	assembly: "mscorlib"
	external_name: "System.UInt32"
	library: "Free implementation of ELKS library"
	status: "See notice at end of class."
	legal: "See notice at end of class."
	date: "$Date: 2015-07-12 20:03:50 +0800 (周日, 12 7月 2015) $"
	revision: "$Revision: 97693 $"

frozen expanded class
	CHARACTER_32

feature -- Access

	item: like Current

	natural_32_code: NATURAL_32
			-- Associated natural value
		do
			Result := item.natural_32_code
		end

feature -- Settings

	set_item (i: like Current)
			-- Make `i' the item value.
		do
			item := i
		ensure
			item_set: item = i
		end

note
	copyright: "Copyright (c) 1984-2015, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
