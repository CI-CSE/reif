note
	description: "Summary description for {WIKI_STYLED_ITEM}."
	author: ""
	date: "$Date: 2013-08-02 17:42:20 +0800 (周五, 02 8月 2013) $"
	revision: "$Revision: 92840 $"

class
	WIKI_STYLED_ITEM

inherit
	WIKI_BOX [WIKI_ITEM]

create
	make,
	make_strike

feature {NONE} -- Initialization

	make
		do
			initialize
		end

	make_strike
		do
			make
		end

note
	copyright: "2011-2013, Jocelyn Fiat and Eiffel Software"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Jocelyn Fiat
			Contact: http://about.jocelynfiat.net/
		]"
end
