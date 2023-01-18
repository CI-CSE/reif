note
	description: "Summary description for {AFX_SHARED_STATE_SERVER}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

class
	AFX_SHARED_STATE_SERVER

feature -- Access

	state_server: AFX_INVARIANT_SERVER
			-- State server
		once
			create Result.make
		end
end
