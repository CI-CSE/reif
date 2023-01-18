note
	description: "Visitor for {SEMQ_QUERY}"
	author: ""
	date: "$Date: 2011-02-23 20:22:02 +0800 (Wed, 23 Feb 2011) $"
	revision: "$Revision: 85692 $"

deferred class
	SEMQ_QUERY_VISITOR

feature -- Process

	process_queryable_query (a_query: SEMQ_QUERYABLE_QUERY)
			-- Process `a_query'.
		deferred
		end

	process_whole_document_query (a_query: SEMQ_WHOLE_QUERYABLE_QUERY)
			-- Process `a_query'.
		deferred
		end

end
