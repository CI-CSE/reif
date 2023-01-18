note

	description:

		"Shared access to XM_XPATH_DEFAULT_NAME_POOL"

	library: "Gobo Eiffel XML Library"
	copyright: "Copyright (c) 2003, Colin Adams and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

class XM_XPATH_SHARED_NAME_POOL

feature -- Access

	shared_name_pool: XM_XPATH_NAME_POOL
			-- Shared name pool
		once
			create Result.make
		ensure
			shared_name_pool_not_void: Result /= Void
		end

end

