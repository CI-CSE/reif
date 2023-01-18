note
	description: "Privileged access to a separate ROUTINE object."
	author: "Roman Schmocker"
	date: "$Date: 2015-12-17 21:34:17 +0800 (周四, 17 12月 2015) $"
	revision: "$Revision: 98279 $"

class
	CP_ROUTINE_ACCESS

inherit
	PROCEDURE
		export {ROUTINE}
			all
		end

feature -- Access

	get_closed_operands (a_routine: separate ROUTINE): detachable separate TUPLE
			-- Get the closed operands of `a_routine'.
		do
			Result := a_routine.closed_operands
		end

end
