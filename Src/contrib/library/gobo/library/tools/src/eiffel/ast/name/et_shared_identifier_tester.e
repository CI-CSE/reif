note

	description:

		"Shared identifier equality testers"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class ET_SHARED_IDENTIFIER_TESTER

feature -- Access

	identifier_tester: ET_IDENTIFIER_TESTER
			-- Identifier equality tester
		once
			create Result
		ensure
			instance_free: class
			identifier_tester_not_void: Result /= Void
		end

end
