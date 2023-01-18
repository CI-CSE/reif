note

	description:

		"Eiffel operators"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

deferred class ET_OPERATOR

inherit

	ET_CALL_NAME

	ET_TOKEN_CODES
		export {NONE} all end

feature -- Access

	lower_name: STRING
			-- Lower-name of feature call
			-- (using UTF-8 encoding)
			-- (May return the same object as `name' if already in lower case.)
		do
			Result := name
		end

end
