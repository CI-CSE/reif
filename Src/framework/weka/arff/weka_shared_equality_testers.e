note
	description: "Shared equality testers"
	author: ""
	date: "$Date: 2010-07-21 23:05:57 +0800 (Wed, 21 Jul 2010) $"
	revision: "$Revision: 83972 $"

class
	WEKA_SHARED_EQUALITY_TESTERS

feature -- Access

	weka_arff_attribute_equality_tester: WEKA_ARFF_ATTRIBUTE_EQUALITY_TESTER
			-- Equality tester for {WEKA_ARFF_ATTRIBUTE}
		once
			create Result
		end

end
