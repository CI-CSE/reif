note
	description: "Summary description for {ESCHER_TEST_CLASS}."
	author: ""
	date: "$Date: 2012-07-10 00:28:45 +0800 (周二, 10 7月 2012) $"
	revision: "$Revision: 89089 $"

class
	ESCHER_TEST_CLASS

inherit

	VERSIONED_CLASS

create
	make

feature {NONE} -- Initialization

	make (some_f: STRING; other_f: INTEGER)
			-- Initialization for `Current'.
		do
			some_field := some_f
			other_field := other_f
		end

feature

	some_field: STRING

	other_field: INTEGER

	version: INTEGER = 3

end
