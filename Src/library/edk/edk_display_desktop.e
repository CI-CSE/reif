note
	description: "Summary description for {EDK_DESKTOP_DISPLAY}."
	author: ""
	date: "$Date: 2009-07-01 09:09:00 +0800 (周三, 01 7月 2009) $"
	revision: "$Revision: 79528 $"

class
	EDK_DISPLAY_DESKTOP

inherit
	EDK_DISPLAY


create
	{EDK_APPLICATION} make_for_application

feature

	frozen native_handle: POINTER
			-- Root Window for display, used for creating new windows.
		external
			"C inline use <edk.h>"
		alias
			"[
				#ifdef EIF_OS = EIF_WINNT
					return HWND_DESKTOP;
				#endif
			]"
		end

end
