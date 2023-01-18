note
	description: "Message logger."
	author: "Yi Wei"
	date: "$Date: 2011-01-28 05:17:05 +0800 (Fri, 28 Jan 2011) $"
	revision: "$Revision: 85488 $"

deferred class
	ELOG_LOGGER

feature -- Basic Operations

	put_string (a_string: STRING)
			-- Log `a_string'.
		deferred
		end
end
