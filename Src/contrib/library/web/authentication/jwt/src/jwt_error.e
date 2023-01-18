note
	description: "Summary description for {JWT_ERROR}."
	date: "$Date: 2017-06-21 00:16:59 +0800 (周三, 21 6月 2017) $"
	revision: "$Revision: 100534 $"

deferred class
	JWT_ERROR

feature -- Access

	id: STRING
		deferred
		end

	message: READABLE_STRING_8
		deferred
		end

end
