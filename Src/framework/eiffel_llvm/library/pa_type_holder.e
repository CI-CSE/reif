note
	description: "Summary description for {PA_TYPE_HOLDER}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	PA_TYPE_HOLDER

create

	make

feature {NONE}

	make (ty: TYPE_L)
		do
			item := make_external (ty.item)
		end

feature

	get: TYPE_L
		do
			create Result.make_from_pointer (get_external (item))
		end

feature

	item: POINTER

feature {NONE}

	get_external (item_a: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Type.h%""
		alias
			"[
				return ((llvm::PATypeHolder *)$item_a)->get ();
			]"
		end

	make_external (ty: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Type.h%""
		alias
			"[
				return new llvm::PATypeHolder ((const llvm::Type *)$ty);
			]"
		end
end
