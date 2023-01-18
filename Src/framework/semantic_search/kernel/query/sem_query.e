note
	description: "Class represents queries to search engine."
	date: "$Date: 2010-10-11 05:45:56 +0800 (Mon, 11 Oct 2010) $"
	revision: "$Revision: 84547 $"

deferred class
	SEM_QUERY

feature -- Process

	process (a_visitor: SEM_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

end
