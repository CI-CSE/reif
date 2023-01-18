note

	description:

		"Singleton1"

	library: "Gobo Eiffel Pattern Library"
	copyright: "Copyright (c) 2003, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-06 07:54:36 +0800 (周三, 06 2月 2019) $"
	revision: "$Revision: 102790 $"

class SINGLETON1

inherit

	ANY -- Needed for SE 2.1.

	SHARED_SINGLETON1

create

	make

feature {NONE} -- Initialization

	make
			-- Create a singleton object.
		require
			singleton1_not_created: not singleton1_created
		do
			singleton1_cell.put (Current)
		end

invariant

	singleton1_created: singleton1_created
	singleton_pattern: Current = singleton1

end
