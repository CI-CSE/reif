note
	description: "Dummy registry implementation"
	author: "Ilinca Ciupa and Andreas Leitner"
	date: "$Date: 2008-12-30 07:00:50 +0800 (周二, 30 12月 2008) $"
	revision: "$Revision: 76429 $"

class
	AUT_REGISTRY
	
inherit
	
	AUT_ABSTRACT_REGISTRY

feature -- Access
		
	subkeys (key: STRING): DS_LINEAR [STRING]
		do
			check 
				dead_end: False 
			end
		end

	string_value (key: STRING): STRING
		do
			check 
				dead_end: False 
			end
		end

feature -- Status report

	is_available: BOOLEAN = False

end
