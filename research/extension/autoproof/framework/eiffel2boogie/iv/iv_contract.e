note
	description: "[
		TODO
	]"
	date: "$Date: 2014-01-24 05:01:03 +0800 (Fri, 24 Jan 2014) $"
	revision: "$Revision: 94089 $"

deferred class
	IV_CONTRACT

feature -- Access

	expression: IV_EXPRESSION
			-- If this contract is an assertions, its expression;
			-- otherwise Void.
		do
		end

feature -- Visitor

	process (a_visitor: IV_CONTRACT_VISITOR)
			-- Process `a_visitor'.
		deferred
		end

end
