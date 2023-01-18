note

	description:

		"Test features of class MEMORY"

	library: "FreeELKS Library"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-06 07:54:36 +0800 (周三, 06 2月 2019) $"
	revision: "$Revision: 102790 $"

class TEST_MEMORY

inherit

	TS_TEST_CASE

	MEMORY

create

	make_default

feature -- Test

	test_is_in_final_collect
			-- Test feature 'is_in_final_collect'.
		do
			assert ("is_in_final_collect1", not is_in_final_collect)
		end

end
