note
	date: "$Date: 2020-10-02 21:51:33 +0800 (周五, 02 10月 2020) $"
	revision: "$Revision: 104756 $"

class
	WSF_FORM_PASSWORD_INPUT

inherit
	WSF_FORM_INPUT

create
	make,
	make_with_text

feature -- Access

	input_type: STRING
		once
			Result := "password"
		end

end
