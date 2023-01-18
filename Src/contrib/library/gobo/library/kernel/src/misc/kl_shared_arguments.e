note

	description:

		"Shared command-line arguments"

	pattern: "Singleton"
	library: "Gobo Eiffel Kernel Library"
	copyright: "Copyright (c) 1999-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class KL_SHARED_ARGUMENTS

feature -- Access

	Arguments: KL_ARGUMENTS
			-- Command-line arguments
		once
			create Result.make
		ensure
			instance_free: class
			arguments_not_void: Result /= Void
		end

end
