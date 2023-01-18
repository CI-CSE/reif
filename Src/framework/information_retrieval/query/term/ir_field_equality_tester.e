note
	description: "Summary description for {IR_FIELD_EQUALITY_TESTER}."
	author: ""
	date: "$Date: 2010-10-07 21:20:22 +0800 (Thu, 07 Oct 2010) $"
	revision: "$Revision: 84524 $"

class
	IR_FIELD_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [IR_FIELD]
		redefine
			test
		end

	IR_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: IR_FIELD): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.name ~ u.name and then
					v.boost = u.boost and then
					ir_value_equality_tester.test (v.value, u.value)
			end
		end

end
