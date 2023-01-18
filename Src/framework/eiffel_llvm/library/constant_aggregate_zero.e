note
	description: "Summary description for {CONSTANT_AGGREGATE_ZERO}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	CONSTANT_AGGREGATE_ZERO

inherit
	CONSTANT

create

	make

feature {NONE}

	make (ty: TYPE_L)
		do
			item := make_external (ty.item)
		end

feature {NONE}

	make_external (ty: POINTER): POINTER
		external
			"C++ inline use %"llvm/IR/Constants.h%""
		alias
			"[
				return llvm::ConstantAggregateZero::get ((llvm::Type *)$ty);
			]"
		end
end
