note
	description: "Summary description for {NS_WINDOW_API}."
	author: "Daniel Furrer"
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	NS_AUTORELEASE_POOL_API

feature -- Creation

	frozen new: POINTER
		external
			"C inline use <Cocoa/Cocoa.h>"
		alias
			"return [NSAutoreleasePool new];"
		end

feature -- Managing a Pool

	frozen release (a_target: POINTER)
		external
			"C inline use <Cocoa/Cocoa.h>"
		alias
			"[(NSAutoreleasePool*)$a_target release];"
		end

	frozen drain (a_target: POINTER)
		external
			"C inline use <Cocoa/Cocoa.h>"
		alias
			"[(NSAutoreleasePool*)$a_target drain];"
		end

end
