note

	description:

		"Shared feature name comparators"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2017-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class ET_SHARED_FEATURE_NAME_COMPARATOR

feature -- Access

	feature_name_comparator: ET_FEATURE_NAME_COMPARATOR
			-- Feature name comparator
		once
			create Result.make
		ensure
			instance_free: class
			feature_name_comparator_not_void: Result /= Void
		end

end
