note
	description: "Summary description for {AFX_FIXING_OPERATION}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

deferred class
	AFX_FIXING_OPERATION

inherit

	AFX_FIXING_OPERATION_CONSTANT

	EPA_HASH_CALCULATOR

	DEBUG_OUTPUT

	AFX_SHARED_SESSION

feature -- Access

	fixing_target: AFX_FIXING_TARGET
			-- Fixing targets associated with the operation.

	operation_text: STRING
			-- Text of the fixing operation.
		deferred
		end

	type: INTEGER
			-- Type of fixing operation.

end
