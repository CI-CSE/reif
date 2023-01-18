note
	description : "Objects that ..."
	author      : "$Author: jfiat $"
	date        : "$Date: 2020-06-24 15:51:11 +0800 (周三, 24 6月 2020) $"
	revision    : "$Revision: 104504 $"

class
	SUGGESTIVE

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		local
			app: EV_APPLICATION
		do
			create app
			create main_window.make
			main_window.show
			app.launch
		end

feature -- Access

	main_window: SUGGESTIVE_WINDOW

invariant

end
