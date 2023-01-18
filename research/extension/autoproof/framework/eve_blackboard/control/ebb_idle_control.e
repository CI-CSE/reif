note
	description: "Blackboard control which doesn't do anything."
	date: "$Date: 2010-11-11 23:11:30 +0800 (Thu, 11 Nov 2010) $"
	revision: "$Revision: 84902 $"

class
	EBB_IDLE_CONTROL

inherit

	EBB_CONTROL

create
	make

feature -- Access

	name: STRING = "Idle"
			-- <Precursor>

feature -- Basic operations

	think
			-- <Precursor>
		do
		end

	create_new_tool_executions
			-- <Precursor>
		do
		end

end
