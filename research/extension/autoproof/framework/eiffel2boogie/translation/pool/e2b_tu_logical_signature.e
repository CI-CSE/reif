note
	description: "Translation unit for the signature of a logical routine."
	date: "$Date: 2014-01-19 00:45:31 +0800 (Sun, 19 Jan 2014) $"
	revision: "$Revision: 94058 $"

class
	E2B_TU_LOGICAL_SIGNATURE

inherit
	E2B_TU_FEATURE

create
	make

feature -- Access

	base_id: STRING = "logical-signature"
			-- <Precursor>

feature -- Basic operations

	translate
			-- <Precursor>
		local
			l_translator: E2B_ROUTINE_TRANSLATOR
		do
			create l_translator.make
			l_translator.translate_logical_signature (feat, type)
		end

end
