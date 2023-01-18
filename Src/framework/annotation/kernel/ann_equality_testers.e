note
	description: "Shared equality testers for annotation related classes"
	author: ""
	date: "$Date: 2011-10-28 04:32:09 +0800 (Fri, 28 Oct 2011) $"
	revision: "$Revision: 87645 $"

class
	ANN_EQUALITY_TESTERS

feature -- Access

	annotation_equality_tester: ANN_ANNOTATION_EQUALITY_TESTER [ANN_ANNOTATION]
			-- Equality tester for annotations
		once
			create Result
		end

end
