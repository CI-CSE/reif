note
	description: "Represents the categorization of a rule regarding severity."
	author: ""
	date: "$Date: 2014-06-11 19:29:01 +0800 (周三, 11 6月 2014) $"
	revision: "$Revision: 95235 $"

deferred class
	CA_RULE_SEVERITY

feature -- Properties

	is_critical: BOOLEAN
			-- Is the severity category critical for program execution?
		deferred
		end

	name: STRING_32
			-- What the severity is called; what is shown to the user.
		deferred
		ensure
			valid_result: Result /= Void
		end

	short_form: STRING_32
			-- Short form (ideally a single character) of the  severity.
		deferred
		ensure
			valid_result: Result /= Void
		end
end
