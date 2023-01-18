note
	description: "[
			Represent an input type color
			Example
			<input id="color" name="color" type="color">
		]"
	date: "$Date: 2017-03-07 21:26:26 +0800 (周二, 07 3月 2017) $"
	revision: "$Revision: 99933 $"
	EIS: "name=color", "src=https://html.spec.whatwg.org/multipage/forms.html#color-state-(type=color)"
class
	WSF_FORM_COLOR_INPUT

inherit
	WSF_FORM_INPUT

create
	make,
	make_with_text

feature -- Access

	input_type: STRING = "color"
end

