note
	description: "Defines the interface that all linear regression parsers must implement."
	author: ""
	date: "$Date: 2010-08-19 19:18:38 +0800 (Thu, 19 Aug 2010) $"
	revision: "$Revision: 84224 $"

deferred class
	RM_LINEAR_REGRESSION_PARSER_INTERFACE

feature -- Access

	last_linear_regression: RM_LINEAR_REGRESSION
		-- Last mined linear regression

feature -- Interface

	parse_linear_regression
			-- Parses the linear regression from the file located at `model_file_path'
		deferred
		end

feature{RM_LINEAR_REGRESSION_PARSER_INTERFACE} -- Internal data holders

	model_file_path: STRING
			-- Absolute path to the model file

end
