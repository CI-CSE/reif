note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"
	testing: "type/manual"

class
	TEST_DEBUG_LOC

inherit
	EQA_TEST_SET

feature -- Test routines

	test_debug_loc_1
		local
			loc: DEBUG_LOC
		do
			assert ("not_implemented", False)
		end

end


