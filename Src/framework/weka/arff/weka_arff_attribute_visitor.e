note
	description: "Process {WEKA_ARFF_ATTRIBUTE} objects"
	author: ""
	date: "$Date: 2010-12-06 17:39:43 +0800 (Mon, 06 Dec 2010) $"
	revision: "$Revision: 85052 $"

deferred class
	WEKA_ARFF_ATTRIBUTE_VISITOR

feature -- Process

	process_boolean_attribute (a_attribute: WEKA_ARFF_BOOLEAN_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

	process_numeric_attribute (a_attribute: WEKA_ARFF_NUMERIC_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

	process_nominal_attribute (a_attribute: WEKA_ARFF_NOMINAL_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

	process_string_attribute (a_attribute: WEKA_ARFF_STRING_ATTRIBUTE)
			-- Process `a_attribute'.
		deferred
		end

end
