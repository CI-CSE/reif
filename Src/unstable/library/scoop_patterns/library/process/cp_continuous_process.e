note
	description: "Active objects which never allow other processor to access their data."
	author: "Roman Schmocker"
	date: "$Date: 2014-10-03 21:37:39 +0800 (周五, 03 10月 2014) $"
	revision: "$Revision: 95848 $"

deferred class
	CP_CONTINUOUS_PROCESS

inherit
	CP_PROCESS

feature -- Basic operations

	start
			-- Start the current process.
		do
			from
				setup
			until
				is_stopped
			loop
				step
			end
			cleanup
		end

end
