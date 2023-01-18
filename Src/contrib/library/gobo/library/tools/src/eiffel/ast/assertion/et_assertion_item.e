note

	description:

		"Eiffel assertions in list of assertions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_ASSERTION_ITEM

inherit

	ET_AST_NODE

feature -- Access

	assertion: ET_ASSERTION
			-- Assertion in list of assertions
		deferred
		ensure
			assertion_not_void: Result /= Void
		end

end
