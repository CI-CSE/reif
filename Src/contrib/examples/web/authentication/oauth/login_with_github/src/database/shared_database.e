note
	description: "Summary description for {SHARED_DATABASE}."
	date: "$Date: 2018-09-07 00:07:18 +0800 (周五, 07 9月 2018) $"
	revision: "$Revision: 102137 $"

class
	SHARED_DATABASE

feature -- Database

	database: separate MESSAGES_API
		once ("PROCESS")
			create Result.make
		end

end
