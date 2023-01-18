note
	description: "Summary description for {AFX_CONSTANTS}."
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

class
	EPA_CONSTANTS

inherit
	ITP_SHARED_CONSTANTS

feature -- Access

	equation_separator: STRING
			-- Separator between the expression and the value in an equation
		do
			Result := query_value_separator
		end

	nonsensical: STRING
			-- Nonsensical value
		do
			Result := nonsensical_value
		end

end
