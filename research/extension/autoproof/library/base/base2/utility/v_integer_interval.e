note
	description: "Summary description for {V_INTEGER_INTERVAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	V_INTEGER_INTERVAL

create
	make

feature

	make (min_index, max_index: INTEGER)
			-- Set up interval to have bounds `min_index' and
			-- `max_index' (empty if `min_index' > `max_index')
		do
			if min_index <= max_index then
				lower := min_index
				upper := max_index
			else
				lower := 1
				upper := 0
			end
		ensure
			lower_defined: lower_defined
			upper_defined: upper_defined
			set_if_non_empty:
				(min_index <= max_index) implies
				((lower = min_index) and
					(upper = max_index))
			empty_if_not_in_order:
				(min_index > max_index) implies is_empty -- (count = 0)
			lower_and_upper_when_empty:
				(min_index > max_index) implies (lower = 1 and upper = 0)
		end

feature -- Access

	lower_defined: BOOLEAN = True
			-- Is there a lower bound?

	lower: INTEGER
			-- Smallest value in interval.

	upper_defined: BOOLEAN = True
			-- Is there an upper bound?

	upper: INTEGER
			-- Largest value in interval.

	is_empty: BOOLEAN
			-- Is structure empty?
		do
			Result := count = 0
		ensure
			Result = (count = 0)
		end

	count: INTEGER
			-- Number of items in interval
		do
			check
				finite: upper_defined and lower_defined
			end
			if upper_defined and lower_defined then
				Result := upper - lower + 1
			end
		ensure then
			definition: Result = upper - lower + 1
		end

end
