note
	description: "Summary description for {SM_LOC}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	SM_LOC

create

	make

feature {NONE}

	make
		do
			item := ctor_external
		end

feature

	item: POINTER

feature {NONE} -- External

	ctor_external: POINTER
		external
			"C++ inline use %"llvm/Support/SMLoc.h%""
		alias
			"[
				return new llvm::SMLoc;		
			]"
		end
end
