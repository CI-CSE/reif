note
	description: "Class representing a feature call token"
	author: ""
	date: "$Date: 2011-08-10 18:19:34 +0800 (Wed, 10 Aug 2011) $"
	revision: "$Revision: 86978 $"

class
	EXT_FEATURE_TOKEN

inherit
	EXT_TOKEN

create
	make

feature{NONE} -- Initialization

	make (a_feature_name: STRING)
			-- Initialize Current.
		do
			feature_name := a_feature_name.twin
		end

feature -- Access

	feature_name: STRING
			-- Name of the feature call

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := feature_name.twin
		end

end
