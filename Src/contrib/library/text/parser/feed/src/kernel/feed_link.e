note
	description: "Link mentioned in feed and feed entry."
	date: "$Date: 2015-10-06 05:04:51 +0800 (周二, 06 10月 2015) $"
	revision: "$Revision: 97960 $"

class
	FEED_LINK

create
	make

feature {NONE} -- Initialization

	make (a_href: READABLE_STRING_8)
		do
			href := a_href
			set_relation (Void)
		end

feature -- Access

	href: READABLE_STRING_8
			-- Location of Current link.

	relation: READABLE_STRING_32
			-- Relation associated with Current link.

	type: detachable READABLE_STRING_8
			-- Optional type of link.

feature -- Element change

	set_relation (rel: detachable READABLE_STRING_GENERAL)
		do
			if rel = Void then
				relation := ""
			else
				relation := rel.as_string_8
			end
		end

	set_type (a_type: detachable READABLE_STRING_GENERAL)
		do
			if a_type = Void then
				type := Void
			else
				type := a_type.as_string_8
			end
		end

feature -- Visitor

	accept (vis: FEED_VISITOR)
		do
			vis.visit_link (Current)
		end

end
