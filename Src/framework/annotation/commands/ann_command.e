note
	description: "Commands for annotation collection"
	author: ""
	date: "$Date: 2011-10-28 04:32:09 +0800 (Fri, 28 Oct 2011) $"
	revision: "$Revision: 87645 $"

deferred class
	ANN_COMMAND

feature -- Access

	config: ANN_CONFIG
			-- Config for annotation collection

feature -- Basic operations

	execute
			-- Execute Current command
		deferred
		end

end
