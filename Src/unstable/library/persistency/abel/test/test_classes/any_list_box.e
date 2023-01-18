note
	description: "Summary description for {ANY_LIST_BOX}."
	author: ""
	date: "$Date: 2013-12-14 08:20:32 +0800 (周六, 14 12月 2013) $"
	revision: "$Revision: 93724 $"

class
	ANY_LIST_BOX

create
	set_items

feature

	items: LINKED_LIST [ANY]

	set_items (an_item: LINKED_LIST [ANY])
		do
			items := an_item
		end


end
