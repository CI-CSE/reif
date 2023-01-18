note
	description: "Summary description for {FEED_HOOK}."
	date: "$Date: 2018-04-28 01:16:56 +0800 (周六, 28 4月 2018) $"
	revision: "$Revision: 101684 $"

deferred class
	FEED_PROVIDER_HOOK

inherit
	CMS_HOOK

feature -- Invocation

	feed (a_location: READABLE_STRING_8): detachable FEED
			-- Feed associated with `a_location`.
		deferred
		end

end
