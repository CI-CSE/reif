note
	description: "A warning. Warnings may lead to dangerous, bad, or unwanted program behavior"
	author: "Stefan Zurfluh"
	date: "$Date: 2014-06-11 19:29:01 +0800 (周三, 11 6月 2014) $"
	revision: "$Revision: 95235 $"

class
	CA_WARNING

inherit
	CA_RULE_SEVERITY

feature -- Properties

	is_critical: BOOLEAN = False
			-- <Precursor>

	name: STRING_32 = "Warning"
			-- <Precursor>

	short_form: STRING_32 = "W"
			-- <Precursor>

end
