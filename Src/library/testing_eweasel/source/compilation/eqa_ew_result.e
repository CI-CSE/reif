note
	description: "Summary description for {EQA_EW_RESULT}."
	author: ""
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

deferred class
	EQA_EW_RESULT

feature {ANY} -- Status setting

	update (a_string: READABLE_STRING_8)
			-- Update `Current' according to last line read from process output.
			--
			-- `a_string': String containing last line read from process.
		deferred
		end

end
