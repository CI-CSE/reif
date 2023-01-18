note
	description: "Interface {CONTACT_MESSAGE} representing the contact's message."
	date: "$Date: 2016-01-23 04:51:35 +0800 (周六, 23 1月 2016) $"
	revision: "$Revision: 98430 $"

class
	CONTACT_MESSAGE

create
	make

feature {NONE} -- Initialization

	make (a_name: like username; a_message: like message)
		do
			username := a_name
			message := a_message
			create date.make_now_utc
		end

feature -- Access

	username: READABLE_STRING_32

	email: detachable READABLE_STRING_8

	message: READABLE_STRING_32

	date: DATE_TIME

feature -- Change

	set_email (e: like email)
		do
			email := e
		end

	set_date (d: like date)
		do
			date := d
		end

end
