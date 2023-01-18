note
	description: "Summary description for {DELEGATE}."
	author: ""
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

deferred class
	DELEGATE

inherit
	ANY
		undefine
			copy
		end

feature -- Access


feature {NS_OBJECT}

	item: POINTER
		deferred
		end

end
