note
	description: "Unspedified domain for a function"
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

class
	EPA_UNSPECIFIED_DOMAIN

inherit
	EPA_FUNCTION_DOMAIN
		redefine
			is_unspecified
		end

feature -- Status report

	is_unspecified: BOOLEAN = True
			-- Does current represent an unspecified domain?

end
