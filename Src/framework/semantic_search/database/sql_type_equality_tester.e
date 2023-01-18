note
	description: "Equality tester for {SQL_TYPE}"
	author: ""
	date: "$Date: 2010-11-07 18:50:34 +0800 (Sun, 07 Nov 2010) $"
	revision: "$Revision: 84856 $"

class
	SQL_TYPE_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [SQL_TYPE]
		redefine
			test
		end

feature -- Status report

	test (v, u: SQL_TYPE): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					v.hash_code = u.hash_code and then
					v.name ~ u.name
			end
		end


end
