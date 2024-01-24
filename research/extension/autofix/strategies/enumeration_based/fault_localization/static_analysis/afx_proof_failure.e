note
	description: "Summary description for {AFX_PROOF_FAILURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_PROOF_FAILURE

create
	make

feature

	make (a_target_class_name: STRING; a_target_routine_name: STRING; a_exception_code: INTEGER; a_line_number: INTEGER; a_failure_msg: STRING)
			-- Initialization
		do
			target_class_name := a_target_class_name
			target_routine_name := a_target_routine_name
			exception_code := a_exception_code
			line_number := a_line_number
			assertion_tag := a_failure_msg
		end

feature	-- Access

	target_class_name: STRING
			-- Name of the target class

	target_routine_name: STRING
			-- Name of the target routine

	exception_code: INTEGER
			-- Type of failure based on constants in {EXCEP_CONST}

	line_number: INTEGER
			-- Index of verification errors in case of multiple failures.

	assertion_tag: STRING
			-- Tag of the failing assertion.
end
