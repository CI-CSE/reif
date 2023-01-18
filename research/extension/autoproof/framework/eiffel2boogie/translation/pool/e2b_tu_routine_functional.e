note
	description: "[
		Translation unit for the functional representation of an Eiffel function.
	]"
	date: "$Date: 2013-10-21 23:20:06 +0800 (Mon, 21 Oct 2013) $"
	revision: "$Revision: 93152 $"

class
	E2B_TU_ROUTINE_FUNCTIONAL

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "functional"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_functional_representation (feat, type)
		end

end
