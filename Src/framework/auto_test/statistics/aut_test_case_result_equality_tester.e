note
	description:

		"Equality tester for class AUT_TEST_CASE_RESULT"

	copyright: "Copyright (c) 2007, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2008-12-30 07:00:50 +0800 (周二, 30 12月 2008) $"
	revision: "$Revision: 76429 $"

class AUT_TEST_CASE_RESULT_EQUALITY_TESTER

inherit

	KL_EQUALITY_TESTER [AUT_TEST_CASE_RESULT]
		redefine
			test
		end

feature -- Status report

	test (v, u: AUT_TEST_CASE_RESULT): BOOLEAN
			-- Are `v' and `u' considered equal?
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.witness.is_same_bug (u.witness)
			end
		end
end
