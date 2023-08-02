note
	description: "Equality tester for {CI_SEQUENCE_SIGNATURE}"
	author: ""
	date: "$Date: 2010-06-16 04:44:45 +0800 (Wed, 16 Jun 2010) $"
	revision: "$Revision: 83582 $"

class
	CI_SEQUENCE_SIGNATURE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [CI_SEQUENCE_SIGNATURE]
		redefine
			test
		end

	EPA_SHARED_EQUALITY_TESTERS

feature -- Status report

	test (v, u: CI_SEQUENCE_SIGNATURE): BOOLEAN
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
