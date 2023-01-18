note
	description: "Summary description for {TICK_TIMER}."
	author: ""
	date: "$Date: 2014-10-03 21:37:39 +0800 (周五, 03 10月 2014) $"
	revision: "$Revision: 95848 $"

class
	TICK_TIMER

inherit
	CP_PERIODIC_PROCESS

create
	make

feature -- Access

	count: INTEGER

feature -- Basic operations

	run
			-- <Precursor>
		do
			count := count + 1
			print ("tick%N")
		end

end
