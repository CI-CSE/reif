note

	description:

		"Eiffel inline agents with an internal (do or once) function as associated feature"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2007, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_INTERNAL_FUNCTION_INLINE_AGENT

inherit

	ET_FUNCTION_INLINE_AGENT
		undefine
			reset, locals
		end

	ET_INTERNAL_ROUTINE_INLINE_AGENT
		rename
			make as make_inline_agent
		undefine
			type, implicit_result
		end

end
