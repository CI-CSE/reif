note
	description: "Summary description for {VECTOR_TYPE}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	VECTOR_TYPE

inherit
	SEQUENTIAL_TYPE

create

	make

feature {NONE}

	make (element_type: TYPE_L; num_elements: NATURAL_32)
		do
			item := make_external (element_type.item, num_elements)
		end

feature {NONE}

	make_external (element_type: POINTER; num_elements: NATURAL_32): POINTER
		external
			"C++ inline use %"llvm/IR/DerivedTypes.h%""
		alias
			"[
				return llvm::VectorType::get ((llvm::Type *)$element_type, $num_elements);
			]"
		end

end
