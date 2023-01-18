note
	description: "Class representing a keyword token"
	author: ""
	date: "$Date: 2011-08-10 18:19:34 +0800 (Wed, 10 Aug 2011) $"
	revision: "$Revision: 86978 $"

class
	EXT_KEYWORD_TOKEN

inherit
	EXT_TOKEN

create
	make

feature{NONE} -- Initialization

	make (a_keyword: STRING)
			-- Initialize Current.
		do
			keyword := a_keyword.twin
		end

feature -- Access

	keyword: STRING
			-- Keyword inside current token

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := keyword.twin
		end

end
