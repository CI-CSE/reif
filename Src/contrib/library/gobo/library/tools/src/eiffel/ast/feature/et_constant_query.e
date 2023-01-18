note

	description:

		"Eiffel constant or unique attributes"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

deferred class ET_CONSTANT_QUERY

inherit

	ET_QUERY

feature -- Access

	constant: ET_CONSTANT
			-- Constant value
		deferred
		ensure
			constant_not_void: Result /= Void
		end

end
