note
	description: "Function domain"
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

deferred class
	EPA_FUNCTION_DOMAIN

feature -- Status report

	is_unspecified: BOOLEAN
			-- Does current represent an unspecified domain?
		do
		end

	is_integer_range: BOOLEAN
			-- Does current represent an integer range domain?
		do
		end

	is_exhaustive: BOOLEAN
			-- Does current represent an exhaustive domain?
		do
		end

end
