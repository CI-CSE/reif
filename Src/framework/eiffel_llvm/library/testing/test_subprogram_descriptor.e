note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"
	testing: "type/manual"

class
	TEST_SUBPROGRAM_DESCRIPTOR

inherit
	EQA_TEST_SET

feature -- Test routines

	test_subprogram_descriptor_1
		local
			subprogram: SUBPROGRAM_DESCRIPTOR
		do
			assert ("not_implemented", False)
		end

end


