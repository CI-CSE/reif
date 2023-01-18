note
	description: "Summary description for {JWT_DEV_ERROR}."
	date: "$Date: 2017-06-21 00:16:59 +0800 (周三, 21 6月 2017) $"
	revision: "$Revision: 100534 $"

class
	JWT_DEV_ERROR

inherit
	JWT_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_id: READABLE_STRING_8; msg: READABLE_STRING_8)
		do
			id := a_id
			message := msg
		end

feature -- Access

	id: STRING

	message: READABLE_STRING_8

end
