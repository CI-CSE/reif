note
	description: "Shared hint tables."
	author: "Paolo Antonucci"
	date: "$Date: 2014-08-21 23:20:29 +0800 (Thu, 21 Aug 2014) $"
	revision: "$Revision: 95696 $"

deferred class
	AT_SHARED_HINT_TABLES

feature -- Hint tables

	Hint_tables: AT_HINT_TABLES
			-- Shared hint tables
		once ("PROCESS")
			create Result
		end

end
