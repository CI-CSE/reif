note
	description: "MYSQL_STMT C Struct Wrapper"
	author: "haroth@student.ethz.ch"
	date: "$Date: 2012-03-16 17:50:04 +0800 (周五, 16 3月 2012) $"
	revision: "$Revision: 88416 $"

class
	MYSQLI_INTERNAL_STATEMENT

inherit
	MEMORY_STRUCTURE
	MYSQLI_EXTERNALS

create{MYSQLI_EXTERNALS}
	make_by_pointer

feature

	structure_size: INTEGER
		do
			Result := size_of_mysql_stmt_struct
		end

end

