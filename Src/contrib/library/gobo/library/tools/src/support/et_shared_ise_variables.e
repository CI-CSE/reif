note

	description:

		"Shared environment variables defined and used in ISE's tools."

	pattern: "Singleton"
	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2010-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class ET_SHARED_ISE_VARIABLES

feature -- Acess

	ise_variables: ET_ISE_VARIABLES
			-- Environment variables defined and used in ISE's tools
		once
			create Result
		ensure
			instance_free: class
			ise_variables_not_void: Result /= Void
		end

end
