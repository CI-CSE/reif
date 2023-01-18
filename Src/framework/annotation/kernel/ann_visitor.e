note
	description: "Visitor to process an annotation"
	author: ""
	date: "$Date: 2011-10-28 04:32:09 +0800 (Fri, 28 Oct 2011) $"
	revision: "$Revision: 87645 $"

deferred class
	ANN_VISITOR

feature -- Processors

	process_mention_annotation (a_ann: ANN_MENTION_ANNOTATION)
			-- Process `a_ann'.
		deferred
		end

	process_sequence_annotation (a_ann: ANN_SEQUENCE_ANNOTATION)
			-- Process `a_ann'.
		deferred
		end

	process_state_annotation (a_ann: ANN_STATE_ANNOTATION)
			-- Process `a_ann'.
		deferred
		end

end
