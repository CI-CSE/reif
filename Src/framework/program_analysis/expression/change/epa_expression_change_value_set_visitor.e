note
	description: "Summary description for {EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR}."
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

deferred class
	EPA_EXPRESSION_CHANGE_VALUE_SET_VISITOR

feature -- Process

	process_expression_change_value_set (a_values: EPA_EXPRESSION_CHANGE_VALUE_SET)
			-- Process `a_values'
		deferred
		end

	process_integer_range (a_values: EPA_INTEGER_RANGE)
			-- Process `a_values'.
		deferred
		end

end
