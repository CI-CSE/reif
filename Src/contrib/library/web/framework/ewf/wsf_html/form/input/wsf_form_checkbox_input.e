note
	description: "Summary description for {WSF_FORM_CHECKBOX_INPUT}."
	author: ""
	date: "$Date: 2017-03-07 21:26:26 +0800 (周二, 07 3月 2017) $"
	revision: "$Revision: 99933 $"

class
	WSF_FORM_CHECKBOX_INPUT

inherit
	WSF_FORM_SELECTABLE_INPUT

create
	make,
	make_with_value

feature -- Access

	input_type: STRING = "checkbox"

invariant

end
