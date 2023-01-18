note
	description: "Summary description for {AFX_POSTCONDITION_VIOLATION_SIGNATURE}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

class
	AFX_POSTCONDITION_VIOLATION_SIGNATURE

inherit
	AFX_ASSERTION_VIOLATION_SIGNATURE

create
	make

feature{NONE} -- Initialization

	make (a_exception_class: CLASS_C; a_exception_feature: FEATURE_I; a_exception_breakpoint: INTEGER)
			-- Initialization.
		do
			set_exception_code ({EXCEP_CONST}.postcondition)
			make_common (a_exception_class, a_exception_feature,
					a_exception_breakpoint, 0,
					a_exception_class, a_exception_feature,
					a_exception_breakpoint, 0)
		end

end
