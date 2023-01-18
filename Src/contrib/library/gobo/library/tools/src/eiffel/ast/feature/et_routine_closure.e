note

	description:

		"Eiffel closures with components common to routines"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2008-2014, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_ROUTINE_CLOSURE

inherit

	ET_FEATURE_CLOSURE
		redefine
			arguments
		end

feature -- Access

	arguments: detachable ET_FORMAL_ARGUMENT_LIST
			-- Formal arguments

end
