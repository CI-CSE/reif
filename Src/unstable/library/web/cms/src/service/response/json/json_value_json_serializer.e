note
	description: "Summary description for {JSON_VALUE_JSON_SERIALIZER}."
	date: "$Date: 2020-10-15 21:26:00 +0800 (周四, 15 10月 2020) $"
	revision: "$Revision: 104782 $"

class
	JSON_VALUE_JSON_SERIALIZER

inherit
	JSON_SERIALIZER

feature -- Conversion

	to_json (obj: detachable ANY; ctx: JSON_SERIALIZER_CONTEXT): JSON_VALUE
			-- JSON value representing the JSON serialization of Eiffel value `obj', in the eventual context `ctx'.	
		do
			if attached {JSON_VALUE} obj as jv then
				Result := jv
			else
				create {JSON_NULL} Result
			end
		end

note
	copyright: "2010-2020, Javier Velilla, Jocelyn Fiat, Eiffel Software and others https://github.com/eiffelhub/json."
	license: "https://github.com/eiffelhub/json/blob/master/License.txt"
end
