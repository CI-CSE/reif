note
	description: "Equality teste for {CI_HASH_SET}"
	author: ""
	date: "$Date: 2010-07-26 06:01:09 +0800 (Mon, 26 Jul 2010) $"
	revision: "$Revision: 84014 $"

class
	CI_HASH_SET_EQUALITY_TESTER [G -> HASHABLE]

inherit
	KL_EQUALITY_TESTER [CI_HASH_SET [G]]
		redefine
			test
		end

feature -- Status report

	test (v, u: CI_HASH_SET [G]): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.is_equal (u)
			end
		end

end
