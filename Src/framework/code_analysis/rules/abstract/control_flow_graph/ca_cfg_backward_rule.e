note
	description: "A rule that iterates backwards on the CFG."
	author: "Stefan Zurfluh"
	date: "$Date: 2016-01-15 22:03:20 +0800 (周五, 15 1月 2016) $"
	revision: "$Revision: 98395 $"

deferred class
	CA_CFG_BACKWARD_RULE

inherit
	CA_CFG_RULE
		rename
			is_ready as is_empty
		end

	CA_CFG_BACKWARD_ITERATOR

end
