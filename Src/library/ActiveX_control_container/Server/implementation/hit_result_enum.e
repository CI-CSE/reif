note
	description: "HITRESULT enumeration. From <ocidl.h>"
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2008-12-30 04:27:11 +0800 (周二, 30 12月 2008) $"
	revision: "$Revision: 76420 $"


class 
	HIT_RESULT_ENUM

feature -- Access 

	Hitresult_outside: INTEGER =  0
	
	Hitresult_transparent: INTEGER =  1
	
	Hitresult_close: INTEGER =  2
	
	Hitresult_hit: INTEGER =  3;


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




end -- class HIT_RESULT_ENUM
