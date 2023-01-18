note
	description: "Summary description for {AFX_FIX_TO_FEATURE}."
	author: ""
	date: "$Date: 2014-03-13 21:12:57 +0800 (Thu, 13 Mar 2014) $"
	revision: "$Revision: 94594 $"

deferred class
	AFX_FIX_TO_FEATURE

feature -- Access

	context_feature: AFX_FEATURE_TO_MONITOR
			-- Target feature of the fix.

feature{AFX_FIX_TO_FEATURE} -- Set

	set_context_feature (a_feature: like context_feature)
			--
		require
			a_feature /= Void
		do
			context_feature := a_feature
		end

end
