note
	description: "[
		Translation unit for the implementatino of an Eiffel routine for qualified calls.
	]"

class
	E2B_TU_QUALIFIED_ROUTINE_IMPLEMENTATION

inherit

	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "qualified-routine-impl"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_routine_implementation_qualified (feat, type)
		end

end
