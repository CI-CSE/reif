note
	description: "AutoProof tool menu extension"

class
	REIF_EXT_ES_TOOL_MENU_EXTENSION

inherit
	TOOL_MENU_EXTENSION_S
	DISPOSABLE_SAFE
	EB_SHARED_PIXMAPS
	EB_SHARED_WINDOW_MANAGER
	SHARED_LOCALE

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
			-- Add new tools in child classes like this:
			-- Precursor (extender)
			--
			-- extender (
			-- 	locale.translation_in_context ("AutoProof", "menu.tool"),
			-- 	icon_pixmaps.verifier_verify_name,
			-- 	True,
			-- 	agent tool_agent ({ES_AUTOPROOF_TOOL})
			-- )
		end

feature {NONE} -- Clean up

	tool_agent (tool_type: TYPE [ES_TOOL [EB_TOOL]])
		local
			c: ES_SHOW_TOOL_COMMAND
		do
			if
				attached window_manager.last_focused_development_window as w and then
				attached w.shell_tools.tool (tool_type) as t
			then
				c := w.commands.show_shell_tool_commands.item (t)
				if c = Void then
					create c.make (t)
					w.auto_recycle (c)
					w.commands.show_shell_tool_commands.force (c, t)
				end
				c.execute
			end
		end

	safe_dispose (a_explicit: BOOLEAN)
			-- <Precursor>
		do
		end

end
