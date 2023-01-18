note
	description: "Summary description for {FOO}."
	author: ""
	date: "$Date: 2013-12-19 05:33:00 +0800 (周四, 19 12月 2013) $"
	revision: "$Revision: 93761 $"

class
	FOO

create
	make

feature

	make (s: READABLE_STRING_GENERAL)
		do
			create bar.make (s)
		end

	bar: BAR

end

