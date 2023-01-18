note

	description:

		"Eiffel assigners"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2005-2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_ASSIGNER

inherit

	ET_AST_NODE

feature -- Initialization

	reset
			-- Reset assigner as it was just after it was last parsed.
		deferred
		end

feature -- Access

	feature_name: ET_FEATURE_NAME
			-- Feature name
		deferred
		ensure
			feature_name_not_void: Result /= Void
		end

end
