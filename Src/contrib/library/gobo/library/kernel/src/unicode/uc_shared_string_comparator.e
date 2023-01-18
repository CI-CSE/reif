note

	description:

		"Shared comparator between strings that can be polymorphically unicode strings"

	library: "Gobo Eiffel Kernel Library"
	copyright: "Copyright (c) 2006-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class UC_SHARED_STRING_COMPARATOR

feature -- Access

	string_comparator: UC_STRING_COMPARATOR
			-- String comparator
		once
			create Result
		ensure
			instance_free: class
			string_comparator_not_void: Result /= Void
		end

end
