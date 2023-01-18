note
	description: "Summary description for {WSF_URI_REWRITER}."
	date: "$Date: 2016-09-27 22:27:21 +0800 (周二, 27 9月 2016) $"
	revision: "$Revision: 99191 $"

deferred class
	WSF_URI_REWRITER

feature	-- Conversion

	uri (a_request: WSF_REQUEST): STRING
			-- Rewritten request uri based on `a_request'.
		deferred
		end

end
