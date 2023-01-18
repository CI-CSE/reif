note

	description:

		"Test 'gelex'"

	copyright: "Copyright (c) 2001-2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-06 07:54:36 +0800 (周三, 06 2月 2019) $"
	revision: "$Revision: 102790 $"

class TEST_GELEX

inherit

	TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING = "gelex"
			-- Program name

feature -- Test

	test_gelex
			-- Test 'gelex'.
		do
			compile_program
		end

end
