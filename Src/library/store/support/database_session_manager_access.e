note
	description: "Session manager access"
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	DATABASE_SESSION_MANAGER_ACCESS

feature -- Access

	manager: DATABASE_SESSION_MANAGER
			-- The session manager
		once
			create Result
		end

end
