note
	description: "Shared access to registry"
	author: "Ilinca Ciupa and Andreas Leitner"
	date: "$Date: 2008-12-30 07:00:50 +0800 (周二, 30 12月 2008) $"
	revision: "$Revision: 76429 $"

class AUT_SHARED_REGISTRY

feature -- Singleton Access

	registry: AUT_REGISTRY
			-- Registry singleton
		once
			create Result
		ensure
			registry_not_void: Result /= Void		
		end

end
