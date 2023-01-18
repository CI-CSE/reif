note
	description: "Summary description for {JWT_UNSUPPORTED_ALG_ERROR}."
	date: "$Date: 2017-06-21 00:16:59 +0800 (周三, 21 6月 2017) $"
	revision: "$Revision: 100534 $"

class
	JWT_UNSUPPORTED_ALG_ERROR

inherit
	JWT_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_alg: READABLE_STRING_8)
		do
			alg := a_alg
		end

feature -- Access

	alg: READABLE_STRING_8

	id: STRING = "ALG"

	message: READABLE_STRING_8
		do
			Result := "Unsupported alg [" + alg + "]"
		end

end
