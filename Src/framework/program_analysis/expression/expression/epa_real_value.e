note
	description: "Class that represents a real value"
	author: ""
	date: "$Date: 2010-06-25 19:15:55 +0800 (Fri, 25 Jun 2010) $"
	revision: "$Revision: 83700 $"

class
	EPA_REAL_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			is_real,
			as_real
		end

create
	make

feature{NONE} -- Initialization

	make (a_item: like item)
			-- Initialize `item' with `a_item'.
		do
			item_cache := a_item
		ensure
			item_set: item = item_cache
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := real_64_type
		end

	item: DOUBLE
			-- Value item in current
		do
			Result := item_cache
		end

	as_real: detachable EPA_REAL_VALUE
			-- Current as integer
		do
			Result := Current
		end

feature -- Status report

	is_real: BOOLEAN = True
			-- Is current a real value?

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_real_value (Current)
		end

feature{NONE} -- Implementation

	item_cache: DOUBLE
			-- Cache for `item'

end
