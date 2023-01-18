note
	description: "Constants in MySQL library"
	author: ""
	date: "$Date: 2011-02-21 22:14:28 +0800 (Mon, 21 Feb 2011) $"
	revision: "$Revision: 85659 $"

class
	MYSQL_CONSTANTS

feature -- Access

	mysql_null_string: STRING = "NULL"
			-- String representation for NULL value
			-- Fixme: cannot distinguish between a string which
			-- contains the exact content "NULL".

end
