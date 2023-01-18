note
	description: "Semantic search query"
	author: ""
	date: "$Date: 2010-11-10 04:47:39 +0800 (Wed, 10 Nov 2010) $"
	revision: "$Revision: 84889 $"

deferred class
	SEMQ_QUERY

feature -- Process

	process (a_visitor: SEMQ_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
