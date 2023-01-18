note
	description: "[
			Message response to notify a forbidden access.
		]"
	date: "$Date: 2015-04-30 16:41:13 +0800 (周四, 30 4月 2015) $"
	revision: "$Revision: 97217 $"

class
	CMS_FORBIDDEN_RESPONSE_MESSAGE

inherit
	CMS_RESPONSE_MESSAGE

create
	make

feature {NONE} -- Initialization

	make
		do
			initialize
			status_code := {HTTP_STATUS_CODE}.forbidden
		end

end
