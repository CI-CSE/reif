note
	description: "Shared access to AUT_FILE_SYSTEM_ROUTINES"
	author: "Ilinca Ciupa and Andreas Leitner"
	date: "$Date: 2008-12-30 07:00:50 +0800 (周二, 30 12月 2008) $"
	revision: "$Revision: 76429 $"

class AUT_SHARED_FILE_SYSTEM_ROUTINES

feature -- Singleton Access

	file_system_routines: AUT_FILE_SYSTEM_ROUTINES
			-- Registry singleton
		once
			create Result.make
		ensure
			routines_not_void: Result /= Void		
		end

end
