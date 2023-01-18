note
	description: "Common ancestor for {JSON_SERIALIZER_CONTEXT and JSON_DESERIALIZER_CONTEXT}."
	date: "$Date: 2016-08-01 15:11:38 +0800 (周一, 01 8月 2016) $"
	revision: "$Revision: 99097 $"

deferred class
	JSON_SERIALIZATION_CONTEXT_I

feature -- Cleaning

	reset
			-- Clean any temporary data.
		deferred
		end

note
	copyright: "2016-2016, Jocelyn Fiat and Eiffel Software"
	license: "Eiffel Forum License v2 (see https://www.eiffel.com/licensing/forum.txt)"
end
