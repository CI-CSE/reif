note
	description: "Equality tester for {SEMQ_TERM} objects"
	author: ""
	date: "$Date: 2010-11-09 05:21:08 +0800 (Tue, 09 Nov 2010) $"
	revision: "$Revision: 84869 $"

class
	SEMQ_TERM_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SEMQ_TERM]
		redefine
			test
		end

feature -- Status report

	test (v, u: SEMQ_TERM): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.text ~ u.text
			end
		end

end
