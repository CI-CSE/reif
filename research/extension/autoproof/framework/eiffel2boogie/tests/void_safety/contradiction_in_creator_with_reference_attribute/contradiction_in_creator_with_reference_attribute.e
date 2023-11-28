note
	description: "[
	This test checks that the generated boogie file does not contain
	contradictory assumptions for creation procedures.
]"
class
	CONTRADICTION_IN_CREATOR_WITH_REFERENCE_ATTRIBUTE

create
	make

feature -- Access

	s: ANY

	make
		note
			status: creator
		do
			check false end
			create s
		end

end
