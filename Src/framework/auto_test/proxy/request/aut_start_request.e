note
	description:

		"Instruction that requests the start of the interprter"

	copyright: "Copyright (c) 2006, Andreas Leitner and others"
	license: "Eiffel Forum License v2 (see forum.txt)"
	date: "$Date: 2012-07-24 05:48:00 +0800 (周二, 24 7月 2012) $"
	revision: "$Revision: 89186 $"

class AUT_START_REQUEST

inherit

	AUT_REQUEST

create

	make

feature -- Processing

	process (a_processor: AUT_REQUEST_PROCESSOR)
			-- Process current request.
		do
			a_processor.process_start_request (Current)
		end

end
