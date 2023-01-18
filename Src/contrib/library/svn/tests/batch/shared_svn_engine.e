note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2010-08-05 18:21:27 +0800 (周四, 05 8月 2010) $"
	revision: "$Revision: 84113 $"

class
	SHARED_SVN_ENGINE

feature -- Access

	svn_engine_provider: SVN_ENGINE_PROVIDER
		once
			create Result.make
		end

end
