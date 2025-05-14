note
	description: "Initialize Autofix extensions"

class
	AFX_ES_SERVICE_INITIALIZER_EXTENSION

inherit
	AP_ES_SERVICE_INITIALIZER_EXTENSION
		redefine
			new_tool_menu_extension_service
		end

feature {NONE} -- Factory

	new_tool_menu_extension_service: TOOL_MENU_EXTENSION_S
			-- New tool menu extension service.
		do
			create {AFX_ES_TOOL_MENU_EXTENSION} Result
		end
end
