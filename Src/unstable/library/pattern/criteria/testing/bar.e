note
	description: "Summary description for {BAR}."
	author: ""
	date: "$Date: 2013-12-19 05:33:00 +0800 (周四, 19 12月 2013) $"
	revision: "$Revision: 93761 $"

class
	BAR

inherit
	ANY
		redefine
			is_equal
		end

create
	make

feature

	make (s: READABLE_STRING_GENERAL)
		do
			value := s
		end

	value: READABLE_STRING_GENERAL

	is_equal (other: like Current): BOOLEAN
		do
			Result := value.same_string (other.value)
		end

end

