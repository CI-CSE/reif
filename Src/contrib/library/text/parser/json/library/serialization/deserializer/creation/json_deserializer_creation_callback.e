note
	description: "Summary description for {JSON_DESERIALIZER_CREATION_CALLBACK}."
	author: ""
	date: "$Date: 2018-11-14 19:33:00 +0800 (周三, 14 11月 2018) $"
	revision: "$Revision: 102453 $"

deferred class
	JSON_DESERIALIZER_CREATION_CALLBACK

feature -- Callback

	on_value_creation (a_value_info: JSON_DESERIALIZER_CREATION_INFORMATION)
		deferred
		end

note
	copyright: "2010-2016, Javier Velilla and others https://github.com/eiffelhub/json."
	license: "https://github.com/eiffelhub/json/blob/master/License.txt"
end
