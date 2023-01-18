note
	description: "[
		Represent the intput type search
		Example
		<input type="search" name="Search">			
	]"
	date: "$Date: 2017-03-07 21:26:26 +0800 (周二, 07 3月 2017) $"
	revision: "$Revision: 99933 $"
	EIS: "name=search", "src=https://html.spec.whatwg.org/multipage/forms.html#text-(type=text)-state-and-search-state-(type=search)"
class
	WSF_FORM_SEARCH_INPUT

inherit
	WSF_FORM_INPUT

create
	make,
	make_with_text

feature -- Access

	input_type: STRING = "search"
end
