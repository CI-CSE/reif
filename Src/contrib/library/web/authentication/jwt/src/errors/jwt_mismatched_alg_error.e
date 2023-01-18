note
	description: "Summary description for {JWT_MISMATCHED_ALG_ERROR}."
	date: "$Date: 2017-10-06 16:12:28 +0800 (周五, 06 10月 2017) $"
	revision: "$Revision: 100831 $"

class
	JWT_MISMATCHED_ALG_ERROR

inherit
	JWT_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_alg, a_header_alg: READABLE_STRING_8)
		do
			alg := a_alg
			header_alg := a_header_alg
		end

feature -- Access

	alg: READABLE_STRING_8

	header_alg: READABLE_STRING_8

	id: STRING = "ALG_MISMATCH"

	message: READABLE_STRING_8
		do
			Result := "Header alg [" + header_alg + "] does not match given alg [" + alg + "]!"
		end

end
