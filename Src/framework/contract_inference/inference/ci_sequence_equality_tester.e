note
	description: "Equality tester for {CI_SEQUENCE_EQUALITY_TESTER}"
	author: ""
	date: "$Date: 2010-10-01 22:01:07 +0800 (Fri, 01 Oct 2010) $"
	revision: "$Revision: 84470 $"

class
	CI_SEQUENCE_EQUALITY_TESTER [G->ANY]

inherit
	KL_EQUALITY_TESTER [CI_SEQUENCE [G]]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_SEQUENCE [G]): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.target_variable_index ~ u.target_variable_index and then
					v.function_name ~ u.function_name
			end
		end

end
