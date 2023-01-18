note
	description: "Summary description for {CMS_PARTIAL_COMMENT}."
	author: ""
	date: "$Date: 2017-01-28 02:00:20 +0800 (周六, 28 1月 2017) $"
	revision: "$Revision: 99767 $"

class
	CMS_PARTIAL_COMMENT

inherit
	CMS_COMMENT

create
	make_with_id

feature {NONE} -- Initialization

	make_with_id (a_cid: like id)
		do
			make
			id := a_cid
		end


end
