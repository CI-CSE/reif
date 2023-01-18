note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2013-05-21 08:05:33 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92558 $"

class
	EIFNET_DEBUG_UNKNOWN_TYPE_VALUE

inherit
	EIFNET_ABSTRACT_DEBUG_VALUE

feature

	debug_value_type_id: INTEGER
		do
		end

	kind: INTEGER
		do
		end

	children: DEBUG_VALUE_LIST
		do
		end

	expandable: BOOLEAN
		do
		end

	type_and_value: STRING_32
		do
		end

	output_value: STRING_32
		do
		end

	dump_value: DUMP_VALUE
		do
		end

	dynamic_class: CLASS_C
		do
		end

end
