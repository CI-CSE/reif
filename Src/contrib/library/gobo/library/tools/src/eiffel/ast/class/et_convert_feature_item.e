note

	description:

		"Eiffel conversion features which appear in a comma-separated list of types"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_CONVERT_FEATURE_ITEM

inherit

	ET_AST_NODE

feature -- Access

	convert_feature: ET_CONVERT_FEATURE
			-- Conversion feature in comma-separated list
		deferred
		ensure
			convert_feature_not_void: Result /= Void
		end

end
