note
	description: "Translation unit for a precondition predicate of a functional representation of a feature."
	date: "$Date: 2014-01-24 05:01:03 +0800 (Fri, 24 Jan 2014) $"
	revision: "$Revision: 94089 $"

class
	E2B_TU_FUNCTION_PRE_PREDICATE

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "fun-pre-predicate"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_function_precondition_predicate (feat, type)
		end

end
