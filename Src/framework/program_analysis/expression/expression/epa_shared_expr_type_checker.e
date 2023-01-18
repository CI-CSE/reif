note
	description: "Summary description for {AFX_SHARED_TYPE_CHECKER}."
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

class
	EPA_SHARED_EXPR_TYPE_CHECKER

feature -- Access

	expression_type_checker: ETR_TYPE_CHECKER
			-- Type checker for expressions
		once
			create Result.make
		end

end
