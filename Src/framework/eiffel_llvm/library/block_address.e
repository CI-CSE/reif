note
	description: "Summary description for {BLOCK_ADDRESS}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	BLOCK_ADDRESS

inherit
	CONSTANT

create

	make

feature {NONE}

	make (bb: BASIC_BLOCK)
		do
			item := make_external (bb.item)
		end

feature {NONE} -- Externals

	make_external (bb: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Constants.h%""
		alias
			"[
				return llvm::BlockAddress::get ((llvm::BasicBlock *)$bb);
			]"
		end
end
