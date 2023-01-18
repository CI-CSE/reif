note
	description: "Summary description for {JWT_INVALID_TOKEN_ERROR}."
	date: "$Date: 2017-06-21 00:16:59 +0800 (周三, 21 6月 2017) $"
	revision: "$Revision: 100534 $"

class
	JWT_INVALID_TOKEN_ERROR

inherit
	JWT_ERROR

feature -- Access

	id: STRING = "INVALID"

	message: READABLE_STRING_8
		do
			Result := "Invalid token"
		end

end
