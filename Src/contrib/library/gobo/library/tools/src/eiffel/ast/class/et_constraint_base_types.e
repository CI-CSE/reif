note

	description:

		"Eiffel base types for the constraints on formal generic parameters"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

deferred class ET_CONSTRAINT_BASE_TYPES

inherit

	ET_CONSTRAINT
		redefine
			type_constraint,
			count
		end

feature -- Access

	type_constraint (i: INTEGER): ET_BASE_TYPE_CONSTRAINT
			-- `i'-th type constraint
		deferred
		end

feature -- Measurement

	count: INTEGER
			-- Number of type constraints in current constraint
		deferred
		ensure then
			count_positive: Result >= 1
		end

end
