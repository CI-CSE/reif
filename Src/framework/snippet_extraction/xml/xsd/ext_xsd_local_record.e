note
	description: "Configuaration record to synthesize element in a XML Schema definition."
	date: "$Date: 2012-01-19 07:49:03 +0800 (Thu, 19 Jan 2012) $"
	revision: "$Revision: 88202 $"

deferred class
	EXT_XSD_LOCAL_RECORD

inherit
	EXT_XSD_RECORD

	DEBUG_OUTPUT

feature -- Access

	parent_node: STRING
		-- Parent node of the `Current' local record.

end
