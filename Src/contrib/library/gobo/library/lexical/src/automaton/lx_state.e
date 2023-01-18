note

	description:

		"States of finite automata"

	library: "Gobo Eiffel Lexical Library"
	copyright: "Copyright (c) 1999, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class LX_STATE

inherit

	KL_CLONABLE

feature -- Status report

	is_accepting: BOOLEAN
			-- Is current state an accepting state?
		deferred
		end

end
