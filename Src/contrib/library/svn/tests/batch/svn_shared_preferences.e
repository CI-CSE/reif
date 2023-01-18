note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2010-08-05 18:21:27 +0800 (周四, 05 8月 2010) $"
	revision: "$Revision: 84113 $"

class
	SVN_SHARED_PREFERENCES


feature -- Access

	preferences: SVN_PREFERENCES
		once
			create Result
		end

end
