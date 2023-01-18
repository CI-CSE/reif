note

	description:

		"Test 'geant'"

	library: "Gobo Eiffel Ant"
	copyright: "Copyright (c) 2001-2002, Sven Ehrke and others"
	license: "MIT License"
	date: "$Date: 2019-07-29 03:03:21 +0800 (周一, 29 7月 2019) $"
	revision: "$Revision: 103356 $"

class TEST_GEANT

inherit

	TOOL_TEST_CASE

create

	make_default

feature -- Access

	program_name: STRING = "geant"
			-- Program name

feature -- Test

	test_geant
			-- Test 'geant'.
		do
			compile_program
		end

end
