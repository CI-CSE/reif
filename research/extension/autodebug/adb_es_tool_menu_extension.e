note
	description: "AutoProof tool menu extension"

class
	ADB_ES_TOOL_MENU_EXTENSION

inherit
	AFX_ES_TOOL_MENU_EXTENSION
		redefine
			extend
		end

feature -- Modification

	extend
		(extender: PROCEDURE [
			READABLE_STRING_32, -- name
			READABLE_STRING_GENERAL, -- icon
			BOOLEAN, -- is_sensitive
			PROCEDURE -- action
		])
			-- <Precursor>
		do
			Precursor (extender)

			extender (
				locale.translation ("AutoFix"),
				icon_pixmaps.command_send_to_external_editor_name,
				True,
				agent tool_agent ({ES_ADB_TOOL})
			)
		end

end
