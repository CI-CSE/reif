note

	description:

		"Imported routines that ought to be in class STRING"

	library: "Gobo Eiffel Kernel Library"
	copyright: "Copyright (c) 1999-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class KL_IMPORTED_STRING_ROUTINES

feature -- Access

	STRING_: KL_STRING_ROUTINES
			-- Routines that ought to be in class STRING
		once
			create Result
		ensure
			instance_free: class
			string_routines_not_void: Result /= Void
		end

end
