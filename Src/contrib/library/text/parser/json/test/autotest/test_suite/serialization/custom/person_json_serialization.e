note
	description: "[
			JSON serializer and JSON deserializer implementation for APP_PERSON objects.
		]"
	date: "$Date: 2016-08-01 15:11:38 +0800 (周一, 01 8月 2016) $"
	revision: "$Revision: 99097 $"

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
