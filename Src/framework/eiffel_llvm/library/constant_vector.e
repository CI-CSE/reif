note
	description: "Summary description for {CONSTANT_VECTOR}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	CONSTANT_VECTOR

inherit
	CONSTANT

create

	make

feature {NONE}

	make (t: VECTOR_TYPE; v: CONSTANT_STLVECTOR)
		obsolete
			"Provide feature with ArrayRef."
		local
			array: CONSTANT_ARRAY_REF
		do
			create array.make_from_vector (v)
			item := make_external (array.item)
		end

feature {NONE}

	make_external (array: POINTER): POINTER
		external
			"C++ inline use <llvm/IR/Constants.h>"
		alias
			"[
				return llvm::ConstantVector::get (*((llvm::ArrayRef <llvm::Constant *> *)$array));
			]"
		end

end
