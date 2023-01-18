note
	description: "Summary description for {BLOCK_DESCRIPTOR_GENERAL}."
	author: ""
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"

class
	BLOCK_DESCRIPTOR_GENERAL

create

	make_null

feature {NONE}

	make_null
		do
			create descriptor.make_null
		end

feature

	descriptor: MD_NODE
end
