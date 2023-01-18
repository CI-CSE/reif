note
	description: "Collection of stateful visitors"
	author: ""
	date: "$Date: 2013-05-21 08:05:33 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92558 $"

class
	SHARED_STATEFUL_VISITOR

feature -- Access

	built_in_processor: BUILT_IN_PROCESSOR
			-- Processor for built-in routines.
		once
			create Result.make
		end

end
