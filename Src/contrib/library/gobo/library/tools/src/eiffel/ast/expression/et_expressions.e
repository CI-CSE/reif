note

	description:

		"Eiffel expression lists"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2006, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

deferred class ET_EXPRESSIONS

feature -- Access

	expression (i: INTEGER): ET_EXPRESSION
			-- Expression at index `i'
		require
			i_large_enough: i >= 1
			i_small_enough: i <= count
		deferred
		ensure
			expression_not_void: Result /= Void
		end

feature -- Measurement

	count: INTEGER
			-- Number of expressions
		deferred
		ensure
			count_not_negative: Result >= 0
		end

end
