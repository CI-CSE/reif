note
	description: "Summary description for {MD_STRING}."
	author: ""
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"

class
	MD_STRING

inherit
	VALUE

create

	make

feature {NONE}

	make (ctx: LLVM_CONTEXT; str: STRING_8)
		local
			c_str: C_STRING
		do
			create c_str.make (str)
			item := make_external (ctx.item, c_str.item)
		end

feature {NONE} -- Externals

	make_external (ctx: POINTER; str: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Metadata.h%""
		alias
			"[
				return llvm::MDString::get (*((llvm::LLVMContext *)$ctx), (const char *)$str);
			]"
		end
end
