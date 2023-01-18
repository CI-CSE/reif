note
	description: "Summary description for {WIKI_IMAGE_RESOLVER}."
	author: ""
	date: "$Date: 2014-08-08 18:28:23 +0800 (周五, 08 8月 2014) $"
	revision: "$Revision: 95589 $"

deferred class
	WIKI_IMAGE_RESOLVER

inherit
	WIKI_ITEM_RESOLVER

feature -- Access

	wiki_url (a_image: WIKI_LINK; a_page: detachable WIKI_PAGE): detachable STRING
			-- URL accessing the wiki image `a_image' in the context of `a_page'.
		deferred
		end

	url (a_image: WIKI_IMAGE_LINK; a_page: detachable WIKI_PAGE): detachable STRING
			-- URL accessing the file associated with the wiki image `a_image', in the context of `a_page'.
		deferred
		end

note
	copyright: "2011-2014, Jocelyn Fiat and Eiffel Software"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Jocelyn Fiat
			Contact: http://about.jocelynfiat.net/
		]"
end
