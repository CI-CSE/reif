note

	description:

		"Shared access to file: URI routines"

	library: "Gobo Eiffel Utility Library"
	copyright: "Copyright (c) 2004-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class UT_SHARED_FILE_URI_ROUTINES

feature -- Access

	File_uri: UT_FILE_URI_ROUTINES
			-- Shared file: URI routines
		once
			create Result
		ensure
			instance_free: class
			file_uri_not_void: Result /= Void
		end

end
