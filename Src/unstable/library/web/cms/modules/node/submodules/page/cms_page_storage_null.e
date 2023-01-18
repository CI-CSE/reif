note
	description: "Summary description for {CMS_PAGE_STORAGE_NULL}."
	author: ""
	date: "$Date: 2017-01-28 02:00:20 +0800 (周六, 28 1月 2017) $"
	revision: "$Revision: 99767 $"

class
	CMS_PAGE_STORAGE_NULL

inherit
	CMS_NODE_STORAGE_NULL

	CMS_PAGE_STORAGE_I

create
	make

feature -- Access

	children (a_node: CMS_NODE): detachable LIST [CMS_NODE]
			-- <Precursor>
		do
		end

	available_parents_for_node (a_node: CMS_NODE): LIST [CMS_NODE]
			-- <Precursor>
		do
			create {ARRAYED_LIST [CMS_NODE]} Result.make (0)
		end
		
end
