note
	description: "Summary description for {}."
	author: ""
	date: "$Date: 2013-01-14 16:17:32 +0800 (Mon, 14 Jan 2013) $"
	revision: "$Revision: 90571 $"

class EPA_STRING_CASE_INSENSITIVE_EQALITY_TESTER

inherit
	KL_EQUALITY_TESTER [STRING]
		redefine
			test
		end

create
	default_create

feature -- Status report

	test (v, u: STRING): BOOLEAN
			-- <Precursor>
		do
			if v = u then
				Result := True
			elseif v = Void or else u = Void then
				Result := False
			else
				Result := u.is_case_insensitive_equal (v)
			end
		end

end
