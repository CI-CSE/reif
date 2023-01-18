note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2011-11-22 05:27:45 +0800 (周二, 22 11月 2011) $"
	revision: "$Revision: 87923 $"

deferred class
	EDK_OBJECT_I

inherit
	DISPOSABLE

feature {NONE} -- Implementation

	property_flags: NATURAL_8
			-- Used for storing boolean flags to save on memory space.

end
