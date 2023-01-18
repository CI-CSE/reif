note
	description: "Partial CMS USER."
	date: "$Date: 2015-04-30 16:41:13 +0800 (周四, 30 4月 2015) $"
	revision: "$Revision: 97217 $"

class
	CMS_PARTIAL_USER

inherit
	CMS_USER

create
	make,
	make_with_id -- MAYBE: export to CMS_STORAGE	

note
	copyright: "2011-2015, Javier Velilla, Jocelyn Fiat, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
