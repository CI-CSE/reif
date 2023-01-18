note

	description:

		"XPath comparsion key testers"

	library: "Gobo Eiffel XPath Library"
	copyright: "Copyright (c) 2004, Colin Adams and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

class XM_XPATH_COMPARISON_KEY_TESTER

inherit

	KL_EQUALITY_TESTER [XM_XPATH_COMPARISON_KEY]
		redefine
			test
		end

feature -- Status report

	test (v, u: XM_XPATH_COMPARISON_KEY): BOOLEAN
			-- Are `v' and `u' considered equal?
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result := v.same_key (u)
			end
		end

end

