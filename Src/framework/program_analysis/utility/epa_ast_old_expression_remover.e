note
	description: "Printer to remove all old expressions of an AST"
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

class
	EPA_AST_OLD_EXPRESSION_REMOVER

inherit
	ETR_AST_STRUCTURE_PRINTER
		redefine
			process_un_old_as
		end

create
	make_with_output

feature{NONE} -- Process

	process_un_old_as (l_as: UN_OLD_AS)
		do
			process_child (l_as.expr, l_as, 2)
		end

end
