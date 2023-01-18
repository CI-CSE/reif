note
	description: "Visitor for {SEM_QUERYABLE}"
	author: ""
	date: "$Date: 2010-10-11 05:45:56 +0800 (Mon, 11 Oct 2010) $"
	revision: "$Revision: 84547 $"

deferred class
	SEM_QUERYABLE_VISITOR

feature -- Process

	process_snippet (a_snippet: SEM_SNIPPET)
			-- Process `a_snippet'.
		deferred
		end

	process_feature_call (a_call: SEM_FEATURE_CALL_TRANSITION)
			-- Process `a_call'.
		deferred
		end

	process_objects (a_objects: SEM_OBJECTS)
			-- Process `a_objects'.
		deferred
		end

end
