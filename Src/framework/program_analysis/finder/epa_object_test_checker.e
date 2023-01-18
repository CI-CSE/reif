note
	description: "Summary description for {EPA_OBJECT_TEST_CHECKER}."
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

class
	EPA_OBJECT_TEST_CHECKER

inherit
	AST_ITERATOR redefine
		process_object_test_as
	end

create
	make

feature{NONE}
	make do
		object_test_found := False
	end

feature
	object_test_found: BOOLEAN

	process_object_test_as (l_as: OBJECT_TEST_AS)
		do
			object_test_found := True
		end

invariant
	invariant_clause: True -- Your invariant here

end
