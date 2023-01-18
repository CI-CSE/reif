note
	description: "Summary description for {SHARED_ORDER_REPOSITORY}."
	author: ""
	date: "$Date: 2015-09-29 02:08:40 +0800 (周二, 29 9月 2015) $"
	revision: "$Revision: 97942 $"

deferred class
	SHARED_ORDER_REPOSITORY

feature
	order_repo : ORDER_REPOSITORY
		once
			create Result.make
		end
end
