note
	description: "Summary description for {AFX_STATE_CHANGE_REQUIREMENT}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

class
	AFX_STATE_CHANGE_REQUIREMENT

create
	make

feature -- Initialization

	make (a_src, a_dest: EPA_EXPRESSION)
			-- Initialization.
		do
			src_expr := a_src
			dest_expr := a_dest
		end

feature -- Access

	src_expr: EPA_EXPRESSION
			-- Source expression to be changed.

	dest_expr: EPA_EXPRESSION
			-- Destination expression, to which `src_expression' will be changed.

end
