note
	description: "Data element which has children."
	date: "$Date: 2010-11-11 23:11:30 +0800 (Thu, 11 Nov 2010) $"
	revision: "$Revision: 84902 $"

deferred class
	EBB_PARENT_ELEMENT [PARENT -> EBB_PARENT_ELEMENT [PARENT, CHILD], CHILD -> EBB_CHILD_ELEMENT [PARENT, CHILD]]

inherit

	EBB_DATA_ELEMENT

feature {NONE} -- Initialization

	make_parent
			-- Initialize parent.
		do
			create {LINKED_LIST [CHILD]} children.make
		end

feature -- Access

	children: attached LIST [CHILD]
			-- Children of this element.

end
