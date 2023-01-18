note
	description: "Objects that define an operation which may be invoked asynchronously."
	author: "Roman Schmocker"
	date: "$Date: 2014-10-03 21:37:39 +0800 (周五, 03 10月 2014) $"
	revision: "$Revision: 95848 $"

deferred class
	CP_STARTABLE

feature -- Basic operations

	start
			-- Launch the operation defined in `Current'.
		deferred
		end

end
