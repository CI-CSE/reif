note

	description: "Parent of any oui graphic class"
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date: 2008-12-30 04:27:11 +0800 (周二, 30 12月 2008) $";
	revision: "$Revision: 76420 $"

class

	G_ANY

feature {NONE} -- Initialization

	init_toolkit: like toolkit
			-- Init toolkit to desired implementation.
		do
		end;

feature -- Access

	toolkit: TOOLKIT
			-- Toolkit of implementation in the environment desired
		once
			Result := init_toolkit
		ensure
			toolkit_exists: Result /= Void
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




end -- G_ANY

