note
	description : "[
				Full html format
			]"
	date: "$Date: 2015-07-18 19:52:26 +0800 (周六, 18 7月 2015) $"
	revision: "$Revision: 97736 $"

class
	FULL_HTML_CONTENT_FORMAT

inherit
	CONTENT_FORMAT
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		do
			Precursor
			create filters.make (2)
			filters.force (create {URL_CONTENT_FILTER})
			debug ("text_filter")
						-- Check if this is ok for a full html content.
				 filters.force (create {LINE_BREAK_TO_HTML_CONTENT_FILTER})
			end
		end

feature -- Access

	name: STRING = "full_html"

	title: STRING_8 = "Full HTML"

	filters: ARRAYED_LIST [CONTENT_FILTER]

end
