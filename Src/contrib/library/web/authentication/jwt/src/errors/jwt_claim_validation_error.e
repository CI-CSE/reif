note
	description: "Summary description for {JWT_CLAIM_VALIDATION_ERROR}."
	date: "$Date: 2017-06-21 00:16:59 +0800 (周三, 21 6月 2017) $"
	revision: "$Revision: 100534 $"

class
	JWT_CLAIM_VALIDATION_ERROR

inherit
	JWT_ERROR

create
	make

feature {NONE} -- Initialization

	make (a_claim: READABLE_STRING_8)
		do
			claim_name := a_claim
		end

feature -- Access

	claim_name: READABLE_STRING_8

	id: STRING = "CLAIM"

	message: READABLE_STRING_8
		do
			Result := "Claim [" + claim_name + "] not validated!"
		end

end
