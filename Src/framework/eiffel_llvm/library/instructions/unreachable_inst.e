note
	description: "Summary description for {UNREACHABLE_INST}."
	author: ""
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"

class
	UNREACHABLE_INST

inherit
	TERMINATOR_INST

create

	make

feature {NONE}

	make (ctx: LLVM_CONTEXT)
		do
			item := make_external (ctx.item)
		end

feature {NONE} -- Externals

	make_external (ctx: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Instructions.h%""
		alias
			"[
				return new llvm::UnreachableInst (*((llvm::LLVMContext *)$ctx));		
			]"
		end
end
