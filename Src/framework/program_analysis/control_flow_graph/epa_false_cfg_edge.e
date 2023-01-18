note
	description: "Summary description for {EPA_FALSE_CFG_EDGE}."
	author: ""
	date: "$Date: 2010-11-21 22:34:23 +0800 (Sun, 21 Nov 2010) $"
	revision: "$Revision: 84969 $"

class
	EPA_FALSE_CFG_EDGE

inherit
	EPA_CFG_EDGE
		redefine
			is_false_branch
		end

create
	make

feature -- Status report

	is_false_branch: BOOLEAN = True
			-- Is Current an false-branch edge?

feature -- Status report

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := (False).out
		end

end
