note
	description: "Configuaration record to synthesize global elements in a XML Schema definition."
	date: "$Date: 2012-01-19 07:49:03 +0800 (Thu, 19 Jan 2012) $"
	revision: "$Revision: 88202 $"

deferred class
	EXT_XSD_RECORD

feature -- Processing

	process_with_parent (a_parent: XML_ELEMENT)
			-- Process `Current' as XML and add it to `a_parent'.
		deferred
		end

end
