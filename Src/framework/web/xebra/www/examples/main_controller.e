note
	description: "[
		Provides features for the servlets
	]"
	legal: "See notice at end of class."
	date: "$Date: 2009-08-29 00:23:36 +0800 (周六, 29 8月 2009) $"
	revision: "$Revision: 80483 $"

class
	MAIN_CONTROLLER

inherit
	XWA_CONTROLLER

create
	make

feature {NONE} -- Initialization	

	make
			-- Initializes Current
		do
			default_create
		end

feature -- Access

	the_text: STRING
		do
			Result := "This is a text"
		end

	my_items: ARRAYED_LIST [STRING]
		do
			create Result.make (3)
			Result.force ("a")
			Result.force ("b")
			Result.force ("c")
		end

	xebra_documentation_url: STRING
		do
			Result := "http://dev.eiffel.com/Xebra_Documentation"
		end

end
