note
	description: "Summary description for {ELF_WRITER}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	ELF_WRITER

inherit
	MACHINE_FUNCTION_PASS

create

	make

feature {NONE}

	make (o: RAW_OSTREAM; tm: TARGET_MACHINE)
		do
--			item := ctor (o.item, tm.item)
		end

feature {NONE} -- Externals

--	ctor (o: POINTER; tm: POINTER): POINTER
--		external
--			"C++ inline use %"llvm/"
--		end

end
