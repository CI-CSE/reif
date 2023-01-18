note
	description: "Summary description for {WSF_URL_API_OPTIONS}."
	author: ""
	date: "$Date: 2013-05-20 21:34:55 +0800 (周一, 20 5月 2013) $"
	revision: "$Revision: 92549 $"

class
	WSF_URL_API_OPTIONS

inherit
	WSF_API_OPTIONS

create
	make,
	make_absolute

feature {NONE} -- Initialization

	make_absolute
		do
			make (1)
			force (True, "absolute")
		end

end
