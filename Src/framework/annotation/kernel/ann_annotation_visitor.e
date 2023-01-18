note
	description: "Annotation visitor"
	author: ""
	date: "$Date: 2011-10-28 04:32:09 +0800 (Fri, 28 Oct 2011) $"
	revision: "$Revision: 87645 $"

deferred class
	ANN_ANNOTATION_VISITOR

feature -- Process

	process_state_annotation (a_annotation: ANN_STATE_ANNOTATION)
			-- Process `a_annotation'.
		deferred
		end
		
end
