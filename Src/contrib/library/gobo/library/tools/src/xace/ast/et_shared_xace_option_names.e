note

	description:

		"Shared Xace option names"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

class ET_SHARED_XACE_OPTION_NAMES

obsolete

	"Use ET_ECF_* classes instead. [2019-03-17]"

feature -- Access

	options: ET_XACE_OPTION_NAMES
			-- Option names
		once
			create Result
		ensure
			options_not_void: Result /= Void
		end

end
