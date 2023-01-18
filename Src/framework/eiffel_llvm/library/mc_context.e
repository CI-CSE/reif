note
	description: "Summary description for {MC_CONTEXT}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	MC_CONTEXT

create

	make

feature {NONE}

	make
		do
			item := ctor_external
		end

feature

	item: POINTER

feature {NONE} -- Externals

	ctor_external: POINTER
		external
			"C++ inline use %"llvm/MC/MCContext.h%""
		alias
			"[
				return new llvm::MCContext ();
			]"
		end
end
