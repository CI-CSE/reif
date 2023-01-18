note

	description:

		"Test 'gecc'"

	copyright: "Copyright (c) 2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-06 07:54:36 +0800 (周三, 06 2月 2019) $"
	revision: "$Revision: 102790 $"

class TEST_GECC

inherit

	TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING = "gecc"
			-- Program name

feature -- Test

	test_gecc
			-- Test 'gecc'.
		do
			compile_program
		end

end
