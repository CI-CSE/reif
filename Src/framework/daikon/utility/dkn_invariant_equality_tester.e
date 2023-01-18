note
	description: "Summary description for {DKN_INVARIANT_EQUALITY_TESTER}."
	author: ""
	date: "$Date: 2010-07-20 16:11:53 +0800 (Tue, 20 Jul 2010) $"
	revision: "$Revision: 83959 $"

class
	DKN_INVARIANT_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [DKN_INVARIANT]
		redefine
			test
		end

feature -- Status report

	test (v, u: DKN_INVARIANT): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.is_expression = u.is_expression and then
					v.text ~ u.text
			end
		end


end
