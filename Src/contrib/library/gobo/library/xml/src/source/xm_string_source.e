note

	description:

		"Strings as source of XML documents"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2001, Andreas Leitner and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

class XM_STRING_SOURCE

inherit

	XM_SOURCE

feature -- Output

	out: STRING
			-- Textual representation
		once
			Result := "STRING"
		end

end
