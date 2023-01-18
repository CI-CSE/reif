note
	description: "[
			Represent the input type url
			Example
			<input type="url" name="url" required>
		]"
	date: "$Date: 2017-03-07 21:26:26 +0800 (周二, 07 3月 2017) $"
	revision: "$Revision: 99933 $"
	EIS: "name=url", "src=https://html.spec.whatwg.org/multipage/forms.html#url-state-(type=url)"

class
	WSF_FORM_URL_INPUT

inherit
	WSF_FORM_INPUT

create
	make,
	make_with_text

feature -- Access

	input_type: STRING = "url"
end
