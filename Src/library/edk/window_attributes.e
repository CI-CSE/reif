note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2015-12-10 22:21:13 +0800 (周四, 10 12月 2015) $"
	revision: "$Revision: 98237 $"

class
	WINDOW_ATTRIBUTES

feature

	toplevel_window: NATURAL
		external
			"C inline use <edk.h>"
		alias
			"[
				#ifdef EIF_OS = EIF_WINNT
					return WS_OVERLAPPEDWINDOW;
				#endif
			]"
		end

	popup_window: NATURAL
		external
			"C inline use <edk.h>"
		alias
			"[
				#ifdef EIF_OS = EIF_WINNT
					return WS_POPUPWINDOW;
				#endif
			]"
		end

end
