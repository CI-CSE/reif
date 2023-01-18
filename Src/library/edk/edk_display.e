note
	description: "Objects that ..."
	author: ""
	date: "$Date: 2011-11-22 05:27:45 +0800 (周二, 22 11月 2011) $"
	revision: "$Revision: 87923 $"

deferred class
	EDK_DISPLAY

inherit
	EDK_SESSION_ID_OBJECT_I
		export {ANY}
			message_manager
		end

feature {NONE} -- Creation

	make_for_application (a_application: EDK_APPLICATION)
			-- Create display object for default display.
		do
			application := a_application
			message_manager_cell.put (create {EDK_DESKTOP_EVENT_MANAGER}.make_for_display (Current))
		end

	application: EDK_APPLICATION
		-- Application object associated with `Current'.

end
