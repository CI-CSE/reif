note
	description: 
		"Root class of Hello World application."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	id: "$Id: hello_world.e 76420 2008-12-29 20:27:11Z manus $"
	date: "$Date: 2008-12-30 04:27:11 +0800 (周二, 30 12月 2008) $"
	revision: "$Revision: 76420 $"
	
class
	HELLO_WORLD

inherit
	EV_APPLICATION

create
	make

feature -- Access

	first_window: MAIN_WINDOW
			-- Main window of the example
		once
			create Result.make_top_level 
			Result.show
		end
	
note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"




end -- class HELLO_WORLD

