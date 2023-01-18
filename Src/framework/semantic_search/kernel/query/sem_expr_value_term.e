note
	description: "A term consists of an expression and a value"
	author: ""
	date: "$Date: 2010-10-13 05:49:19 +0800 (Wed, 13 Oct 2010) $"
	revision: "$Revision: 84569 $"

deferred class
	SEM_EXPR_VALUE_TERM

inherit
	SEM_TERM

feature -- Access

	expression: EPA_EXPRESSION
			-- Expression of `equation'
		deferred
		end

	value: EPA_EXPRESSION_VALUE
			-- Value of `equation'
		deferred
		end

	type: TYPE_A
			-- Type of `equation'
		deferred
		end


end
