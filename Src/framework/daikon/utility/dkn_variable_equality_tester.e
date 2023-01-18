note
	description: "Equality tester for {DKN_VARIABLE}"
	author: ""
	date: "$Date: 2010-06-09 22:41:50 +0800 (Wed, 09 Jun 2010) $"
	revision: "$Revision: 83483 $"

class
	DKN_VARIABLE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [DKN_VARIABLE]
		redefine
			test
		end

feature -- Status report

	test (v, u: DKN_VARIABLE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.daikon_name ~ u.daikon_name
			end
		end

end
