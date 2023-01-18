note
	description: "Summary description for {NS_IMAGE_CELL}."
	author: "Daniel Furrer"
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	NS_IMAGE_CELL

inherit
	NS_CELL

create
	make

feature -- Creation

	make
		do
			make_from_pointer (new)
		end

feature {NONE} -- Implementation

	frozen new: POINTER
		external
			"C inline use <Cocoa/Cocoa.h>"
		alias
			"return [NSImageCell new];"
		end

end
