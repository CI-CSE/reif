note
	description: "Translation unit for the postcondition predicate of an Eiffel routine."
	date: "$Date: 2014-01-16 01:59:02 +0800 (Thu, 16 Jan 2014) $"
	revision: "$Revision: 94003 $"

class
	E2B_TU_ROUTINE_POST_PREDICATE

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "post-predicate"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_postcondition_predicate (feat, type)
		end

end
