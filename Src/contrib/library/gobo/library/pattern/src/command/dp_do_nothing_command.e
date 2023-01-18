note

	description:

		"Commands that do nothing"

	library: "Gobo Eiffel Pattern Library"
	copyright: "Copyright (c) 2001, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2016-05-07 03:15:38 +0800 (周六, 07 5月 2016) $"
	revision: "$Revision: 98678 $"

class DP_DO_NOTHING_COMMAND

inherit

	DP_COMMAND

create

	make

feature {NONE} -- Initialization

	make
			-- Create a new command.
		do
		end

feature -- Execution

	execute
			-- Execute current command.
		do
				-- Do nothing.
		end

end
