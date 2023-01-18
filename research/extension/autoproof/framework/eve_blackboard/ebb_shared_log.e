note
	description: "Access to shared instance of log."
	date: "$Date: 2010-08-23 22:50:18 +0800 (Mon, 23 Aug 2010) $"
	revision: "$Revision: 84261 $"

class
	EBB_SHARED_LOG

feature {NONE} -- Access

	log: EBB_LOG
			-- Shared log.
		do
			Result := log_cell.item
		end

feature {NONE} -- Implementation

	log_cell: CELL [EBB_LOG]
			-- Cell to hold shared log instance.
		once
			create Result.put (create {EBB_LOG})
		end

end
