note

	description:

		"Eiffel feature names which appear in a comma-separated list of feature names"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2002-2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2020-01-08 18:24:11 +0800 (周三, 08 1月 2020) $"
	revision: "$Revision: 103831 $"

deferred class ET_FEATURE_NAME_ITEM

inherit

	ET_EXTENDED_FEATURE_NAME

feature -- Access

	alias_names: detachable ET_ALIAS_NAME_LIST
			-- Alias names, if any
		do
		end

end
