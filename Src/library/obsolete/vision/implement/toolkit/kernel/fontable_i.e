note

	description: "Widgets which define a font"
	legal: "See notice at end of class.";
	status: "See notice at end of class.";
	date: "$Date: 2008-12-30 04:27:11 +0800 (周二, 30 12月 2008) $";
	revision: "$Revision: 76420 $"

deferred class

	FONTABLE_I 

feature -- Access

	font: FONT
			-- Font name of label
		deferred
		end

feature -- Element change

	set_font (a_font: FONT)
			-- Set font label to `font_name'.
		require
			a_font_exists: a_font /= Void
			a_font_specified: a_font.is_specified
		deferred
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




end -- class FONTABLE_I

