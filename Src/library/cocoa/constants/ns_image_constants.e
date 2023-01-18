note
	description: "Summary description for {NS_IMAGE_CONSTANTS}."
	author: "Daniel Furrer"
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	NS_IMAGE_CONSTANTS

feature -- Access

	image_name_info: NS_STRING
		once
			create Result.make_weak_from_pointer ({NS_IMAGE}.image_name_info)
		end

end
