note
	description: "[
			Template to be used with missing theme.
		]"
	date: "$Date: 2014-11-20 03:00:19 +0800 (周四, 20 11月 2014) $"
	revision: "$Revision: 96123 $"

class
	MISSING_CMS_TEMPLATE

inherit

	CMS_TEMPLATE

create
	make

feature {NONE} -- Implementation

	make (a_theme: MISSING_CMS_THEME)
			-- Instantiate Current template based on theme `a_theme'.
		do
			theme := a_theme
		end

feature -- Access

	theme: MISSING_CMS_THEME
			-- <Precursor>

	variables: STRING_TABLE [detachable ANY]
			-- <Precursor>
		do
			create Result.make (0)
		end

	prepare (page: CMS_HTML_PAGE)
			-- <Precursor>
		do
		end

	to_html (page: CMS_HTML_PAGE): STRING
			-- <Precursor>
		do
			Result := " "
		end

end
