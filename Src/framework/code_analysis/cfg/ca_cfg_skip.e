note
	description: "Represents a skip block in the CFG. This block contains no other information than incoming and outgoing edges."
	author: "Stefan Zurfluh"
	date: "$Date: 2014-01-10 21:55:44 +0800 (周五, 10 1月 2014) $"
	revision: "$Revision: 93953 $"

class
	CA_CFG_SKIP

inherit
	CA_CFG_BASIC_BLOCK

create
	make

feature {NONE} -- Initialization

	make (a_label: INTEGER)
			-- Initializes `Current' and sets its label to `a_label'.
		do
			initialize
			label := a_label
		end

end
