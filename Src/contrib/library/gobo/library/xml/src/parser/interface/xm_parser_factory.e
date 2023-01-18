note

	description:

		"Factory interface for XML parsers"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class XM_PARSER_FACTORY

feature -- Status report

	is_parser_available: BOOLEAN
			-- Is XML parser available?
		deferred
		end

feature -- Access

	new_parser: XM_PARSER
			-- New XML parser
		require
			parser_available: is_parser_available
		deferred
		ensure
			parser_not_void: Result /= Void
		end

end
