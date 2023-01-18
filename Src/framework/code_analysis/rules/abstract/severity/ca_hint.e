note
	description: "A hint. Hints are not necessarily meant to implement. They just represent an alternative way of coding something."
	author: "Stefan Zurfluh"
	date: "$Date: 2014-06-11 19:29:01 +0800 (周三, 11 6月 2014) $"
	revision: "$Revision: 95235 $"

class
	CA_HINT

inherit
	CA_RULE_SEVERITY

feature {NONE} -- Initialization

	is_critical: BOOLEAN = False
			-- <Precursor>

	name: STRING_32 = "Hint"
			-- <Precursor>

	short_form: STRING_32 = "H"
			-- <Precursor>

end
