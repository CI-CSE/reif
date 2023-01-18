note
	description: "Summary description for {ANY_BOX}."
	author: ""
	date: "$Date: 2013-10-08 03:35:47 +0800 (周二, 08 10月 2013) $"
	revision: "$Revision: 93079 $"

class
	ANY_BOX
create
	set_item

feature

	item: ANY

	set_item (an_item: ANY)
		do
			item := an_item
		end

end
