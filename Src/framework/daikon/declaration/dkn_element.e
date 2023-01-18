note
	description: "Daikon element"
	author: ""
	date: "$Date: 2010-06-09 22:41:50 +0800 (Wed, 09 Jun 2010) $"
	revision: "$Revision: 83483 $"

deferred class
	DKN_ELEMENT

feature -- Access

	daikon_name: STRING
			-- Name of current element
			-- This is the name directly output to Daikon related files,
			-- thus, space are encoded as "\_", for example, "has\_(o)".
			-- If you want to get an decoded name, use `interface_name'.

	name: STRING
			-- Name of current element, with normal space

end
