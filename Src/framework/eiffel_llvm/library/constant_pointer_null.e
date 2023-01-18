note
	description: "Summary description for {CONSTANT_POINTER_NULL}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	CONSTANT_POINTER_NULL

inherit
	CONSTANT

create

	make

feature {NONE}

	make (t: POINTER_TYPE)
		do
			item := make_external (t.item)
		end

feature {NONE} -- Externals

	make_external (t: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Constants.h%""
		alias
			"[
				return llvm::ConstantPointerNull::get ((llvm::PointerType *)$t);
			]"
		end
end
