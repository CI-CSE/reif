note
	description: "Console logger"
	author: "Jason Yi Wei"
	date: "$Date: 2011-01-28 05:17:05 +0800 (Fri, 28 Jan 2011) $"
	revision: "$Revision: 85488 $"

class
	ELOG_CONSOLE_LOGGER

inherit
	ELOG_LOGGER

feature -- Access

	put_string (a_string: STRING)
			-- Log `a_string'.		
		do
			print (a_string)
		end
end
