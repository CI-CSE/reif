note
	description: "Semantic query executor"
	author: ""
	date: "$Date: 2010-10-13 05:49:19 +0800 (Wed, 13 Oct 2010) $"
	revision: "$Revision: 84569 $"

deferred class
	SEM_QUERY_EXECUTOR

feature -- Access

	last_result: detachable IR_QUERY_RESULT
			-- Result returned by last `execute'.

feature -- Basic operations

	execute (a_query: SEM_QUERY)
			-- Executor `a_query', make result available in `last_result'.
		deferred
		end

end
