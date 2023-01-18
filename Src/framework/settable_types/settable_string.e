note
	description: "[
		STRING implementation of SETTABLE_TYPES [G]
	]"
	legal: "See notice at end of class."
	status: "Prototyping phase"
	date: "$Date: 2013-02-05 05:27:38 +0800 (周二, 05 2月 2013) $"
	revision: "$Revision: 91160 $"
class
	SETTABLE_STRING

inherit
	SETTABLE_TYPES [STRING]

create
	set_value,
	make_empty

convert
	set_value ({STRING}),
	value: {STRING,READABLE_STRING_8}

feature -- Element change

	create_internal_value
			-- <Precursor:
		do
			create internal_value.make_empty
		end

end

