note
	description:
		"[
			Null resolver that always fails

			Note: the original code is from Gobo's XM library (http://www.gobosoft.com/)
		]"		
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"
	
class XML_NULL_EXTERNAL_RESOLVER

inherit
	
	XML_EXTERNAL_RESOLVER

feature -- Action(s)

	resolve (a_system: STRING)
			-- Fails.
		do
		ensure then
			fails: has_error
		end
		
feature -- Result

	has_error: BOOLEAN
			-- Always true
		do
			Result := True
		ensure then
			fails: Result
		end
		
	last_error: detachable STRING
			-- Error message.
		do
			Result := "external entities not supported"
		end
	
	last_stream: detachable XML_INPUT_STREAM
			-- Not used.
		do
		ensure then
			never_called: False
		end

end
