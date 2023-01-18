note

	description:

		"Test 'gecop'"

	copyright: "Copyright (c) 2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-29 03:03:21 +0800 (周一, 29 7月 2019) $"
	revision: "$Revision: 103356 $"

class TEST_GECOP

inherit

	TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING = "gecop"
			-- Program name

feature -- Test

	test_gecop
			-- Test 'gecop'.
		do
			compile_program
		end

end
