note
	description: "[
			Serializer to ignore a specific type of object.
			
			Register it using the {TYPE_NAME} you want to ignore.
		]"
	date: "$Date: 2018-12-19 23:02:55 +0800 (周三, 19 12月 2018) $"
	revision: "$Revision: 102640 $"

class
	JSON_IGNORE_SERIALIZER [G]

inherit
	JSON_SERIALIZER

feature -- Conversion

	to_json (obj: detachable ANY; ctx: JSON_SERIALIZER_CONTEXT): JSON_VALUE
		do
			create {JSON_NULL} Result
		end

note
	copyright: "2010-2018, Javier Velilla, Jocelyn Fiat, Eiffel Software and others https://github.com/eiffelhub/json."
	license: "https://github.com/eiffelhub/json/blob/master/License.txt"
end
