note
	description: "Initialize AutoDebug extensions"

class
	ADB_ES_SERVICE_INITIALIZER_EXTENSION

inherit
	AFX_ES_SERVICE_INITIALIZER_EXTENSION
		redefine
			new_tool_menu_extension_service
		end

feature {NONE}

	new_tool_menu_extension_service: TOOL_MENU_EXTENSION_S
			-- Tool menu with AutoDebug extensions
		do
			create {ADB_ES_TOOL_MENU_EXTENSION} Result
		end
end
