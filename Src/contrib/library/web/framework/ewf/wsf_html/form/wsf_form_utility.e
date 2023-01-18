note
	description: "Summary description for {WSF_FORM_UTILITY}."
	author: ""
	date: "$Date: 2020-05-07 03:46:09 +0800 (周四, 07 5月 2020) $"
	revision: "$Revision: 104124 $"

class
	WSF_FORM_UTILITY

feature -- Converter

	html_encoded_string (s: READABLE_STRING_GENERAL): STRING_8
		do
			Result := html_encoder.general_encoded_string (s)
		end

	html_encoder: HTML_ENCODER
		once
			create Result
		end

end
