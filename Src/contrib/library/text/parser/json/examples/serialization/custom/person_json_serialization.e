note
	description: "[
			JSON serializer and JSON deserializer implementation for APP_PERSON objects.
		]"
	date: "$Date: 2018-11-14 19:33:00 +0800 (周三, 14 11月 2018) $"
	revision: "$Revision: 102453 $"

class
	PERSON_JSON_SERIALIZATION

inherit
	PERSON_JSON_SERIALIZER
		redefine
			reset
		end

	PERSON_JSON_DESERIALIZER
		redefine
			reset
		end

feature -- Cleaning

	reset
			-- <Precursor>
		do
			Precursor {PERSON_JSON_SERIALIZER}
			Precursor {PERSON_JSON_DESERIALIZER}
		end



end
