note
	description: "Collect tests to make it easier to debug."
	date: "$Date: 2020-11-13 03:15:16 +0800 (周五, 13 11月 2020) $"
	revision: "$Revision: 104864 $"

class
	TEST_BASE_EXTENSION

create
	make

feature

	make
		local
			test_graph: TEST_GRAPH
		do
			create test_graph.make
		end

note
	copyright: "Copyright (c) 1984-2020, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
