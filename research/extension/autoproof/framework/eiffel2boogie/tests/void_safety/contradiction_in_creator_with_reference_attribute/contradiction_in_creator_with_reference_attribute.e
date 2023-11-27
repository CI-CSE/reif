note
	description: "Summary description for {CONTRADICTION_IN_FEATURE_CALLED_BY_CREATOR}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONTRADICTION_IN_CREATOR_WITH_REFERENCE_ATTRIBUTE

create
	make

feature -- Access

	s: ANY

	make
		note
			status: creator
			explicit: wrapping, contracts
		do
			check false end
			create s
			check false end
		end

end
