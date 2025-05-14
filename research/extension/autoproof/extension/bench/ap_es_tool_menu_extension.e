note
	description: "AutoProof tool menu extension"

class
	AP_ES_TOOL_MENU_EXTENSION

inherit
	REIF_EXT_ES_TOOL_MENU_EXTENSION
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
			extender (
				locale.translation_in_context ("AutoProof", "menu.tool"),
				icon_pixmaps.verifier_verify_name,
				True,
				agent tool_agent ({ES_AUTOPROOF_TOOL})
			)
		end

end
