note
	description: "Summary description for {WIKI_LINE_SEPARATOR}."
	author: ""
	date: "$Date: 2013-08-02 17:42:20 +0800 (周五, 02 8月 2013) $"
	revision: "$Revision: 92840 $"

class
	WIKI_LINE_SEPARATOR

inherit
	WIKI_ITEM

feature -- Visitor

	process (a_visitor: WIKI_VISITOR)
		do
			a_visitor.visit_line_separator (Current)
		end

note
	copyright: "2011-2013, Jocelyn Fiat and Eiffel Software"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Jocelyn Fiat
			Contact: http://about.jocelynfiat.net/
		]"
end
