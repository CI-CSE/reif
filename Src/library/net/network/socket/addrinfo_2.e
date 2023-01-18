note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class

	ADDRINFO_2

inherit

	ADDRINFO_1
		redefine
			c_free
		end

create

	make_from_external

feature {NONE} -- Externals

	c_free (obj_ptr: POINTER)
		do
		end

end

