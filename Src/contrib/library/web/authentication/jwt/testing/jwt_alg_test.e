note
	description: "Summary description for {JWT_ALG_TEST}."
	author: ""
	date: "$Date: 2018-10-17 16:55:56 +0800 (周三, 17 10月 2018) $"
	revision: "$Revision: 102331 $"

class
	JWT_ALG_TEST

inherit
	JWT_ALG

feature -- Access

	name: STRING = "test"

	encoded_string (a_message: READABLE_STRING_8; a_secret: READABLE_STRING_8): STRING
		do
			Result := "TEST<<"+ a_message + ">>"
		end

end
