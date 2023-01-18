note

	description:

		"Eiffel writable entities"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2004, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_WRITABLE

inherit

	ET_EXPRESSION

feature -- Status report

	is_result: BOOLEAN
			-- Is current expression the 'Result' entity?
		do
			-- Result := False
		end

end
