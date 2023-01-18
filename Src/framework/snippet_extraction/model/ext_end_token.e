note
	description: "Summary description for {EXT_END_TOKEN}."
	author: ""
	date: "$Date: 2011-08-10 18:19:34 +0800 (Wed, 10 Aug 2011) $"
	revision: "$Revision: 86978 $"

class
	EXT_END_TOKEN

inherit
	EXT_TOKEN

feature -- Access

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := "SNIPPET_END"
		end

end
