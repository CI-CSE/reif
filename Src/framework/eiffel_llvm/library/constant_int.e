note
	description: "Summary description for {CONSTANT_INT}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	CONSTANT_INT

inherit
	CONSTANT

create

	make

feature {NONE}

	make (ty: INTEGER_TYPE; v: NATURAL_64)
		do
			item := make_external (ty.item, v)
		end

feature {NONE}

	make_external (ty: POINTER; v: NATURAL_64): POINTER
		external
			"C++ inline use %"llvm/IR/Constants.h%""
		alias
			"[
				return llvm::ConstantInt::get ((llvm::IntegerType *)$ty, $v);
			]"
		end
end
