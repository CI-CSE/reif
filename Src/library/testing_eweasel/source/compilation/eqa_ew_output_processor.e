note
	description: "Summary description for {EQA_EW_OUTPUT_PROCESSOR}."
	author: ""
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	EQA_EW_OUTPUT_PROCESSOR [G -> EQA_EW_RESULT create default_create end]

inherit
	EQA_SYSTEM_OUTPUT_PROCESSOR
		redefine
			on_new_line
		end

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current' with empty result.
		do
			initialize_buffer
			reset_result
		end

feature -- Query

	current_result: G
			-- Current compilation result obtained from processing output

feature --Basic operations

	reset_result
			-- Reset `current_result' with a default result.
		do
			create current_result
		end

feature {NONE} -- Implementation

	on_new_line
			-- <Precursor>
		do
			current_result.update (buffer)
		end

end
