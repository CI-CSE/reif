note
	description: "An invariant detected by Daikon"
	author: ""
	date: "$Date: 2010-08-28 20:33:43 +0800 (Sat, 28 Aug 2010) $"
	revision: "$Revision: 84319 $"

deferred class
	DKN_INVARIANT

inherit
	HASHABLE

	DEBUG_OUTPUT

feature -- Access

	text: STRING
			-- Text of current invariant
		deferred
		end
		
feature -- Status report

	is_expression: BOOLEAN
			-- Is current invariant an expression?
		do
		end

	is_one_of: BOOLEAN
			-- Is current an "one of" invariant?
		do
		end

end
