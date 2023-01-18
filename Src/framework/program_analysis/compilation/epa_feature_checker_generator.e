note
	description: "Type checker and byte-code generator"
	author: ""
	date: "$Date: 2010-10-23 02:10:29 +0800 (Sat, 23 Oct 2010) $"
	revision: "$Revision: 84688 $"

class
	EPA_FEATURE_CHECKER_GENERATOR

inherit
	AST_FEATURE_CHECKER_GENERATOR
		export{ANY}
			break_point_slot_count,
			context,
			check_locals,
			error_handler
		end

end
