note
	description: "Handle to an asynchronous computation which returns a result."
	author: "Roman Schmocker"
	date: "$Date: 2014-10-03 21:37:39 +0800 (周五, 03 10月 2014) $"
	revision: "$Revision: 95848 $"

deferred class
	CP_RESULT_PROMISE [G]

inherit
	CP_PROMISE

feature -- Access

	item: detachable separate G
			-- The generated result.
			-- May be void in case of an exception.
		require
			terminated: is_terminated
		deferred
		end

end
