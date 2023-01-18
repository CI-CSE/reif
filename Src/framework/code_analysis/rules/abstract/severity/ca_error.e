note
	description: "An error. Errors are critical for program execution."
	author: "Stefan Zurfluh"
	date: "$Date: 2014-06-11 19:29:01 +0800 (周三, 11 6月 2014) $"
	revision: "$Revision: 95235 $"

class
	CA_ERROR

inherit
	CA_RULE_SEVERITY

feature -- Properties

	is_critical: BOOLEAN = True
			-- <Precursor>

	name: STRING_32 = "Error"
			-- <Precursor>

	short_form: STRING_32 = "E"
			-- <Precursor>

end
