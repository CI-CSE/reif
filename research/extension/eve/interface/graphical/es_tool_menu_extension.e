note
	description: "An implementation of a tool menu extension service."

class
	ES_TOOL_MENU_EXTENSION

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
			across
				{ARRAY [TUPLE [
					type: TYPE [ES_TOOL [EB_TOOL]];
					title: STRING_32;
					icon_name: READABLE_STRING_8]]}
				<<
					[{ES_AUTOPROOF_TOOL},
						locale.translation_in_context ("AutoProof", "menu.tool"),
						icon_pixmaps.verifier_verify_name],
					[{ES_BLACKBOARD_TOOL},
						locale.translation ("Verification Assistant"),
						icon_pixmaps.tool_watch_name],
					[{ES_EVE_AUTOFIX_TOOL},
						locale.translation ("AutoFix Results"),
						icon_pixmaps.command_send_to_external_editor_name],
					[{ES_ALIAS_ANALYSIS_TOOL},
						{STRING_32} "Alias Analysis",
						icon_pixmaps.compile_success_name],
					[{ES_ADB_TOOL},
						locale.translation ("AutoFix"),
						icon_pixmaps.command_send_to_external_editor_name],
					[{ES_SCHEMA_EVOLUTION_TOOL},
						{STRING_32} "Schema evolution manager",
						icon_pixmaps.tool_class_name],
					[{ES_SPELLING_TOOL},
						locale.translation ("Spell Checker"),
						icon_pixmaps.command_send_to_external_editor_name],
					[{ES_JAVASCRIPT_TOOL},
						{STRING_32} "JavaScript Compiler",
						icon_pixmaps.project_finalize_name]
				>> as tool loop
					extender (
						tool.title,
						tool.icon_name,
						True,
						agent tool_agent (tool.type)
					)
			end
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

note
	date: "$Date$"
	revision: "$Revision$"
	copyright: "Copyright (c) 2018-2021, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
