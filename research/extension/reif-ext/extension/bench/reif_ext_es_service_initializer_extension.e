note
	description: "Base class for Reif extension classes"

deferred class
	REIF_EXT_ES_SERVICE_INITIALIZER_EXTENSION

inherit
	ES_SERVICE_INITIALIZER
		redefine
			add_core_services
		end

feature -- Services

	add_core_services (c: SERVICE_CONTAINER_S)
			-- <Precursor>
		do
			Precursor {ES_SERVICE_INITIALIZER} (c)

			c.register_with_activator ({CONTEXT_MENU_EXTENSION_S}, agent new_context_menu_extension_service, False)
			c.register_with_activator ({TOOL_MENU_EXTENSION_S}, agent new_tool_menu_extension_service, False)
			c.register_with_activator ({COMMAND_LINE_OPTION_EXTENSION_S}, agent new_command_line_option_extension_service, False)
		end

feature {NONE} -- Factory

	new_context_menu_extension_service: CONTEXT_MENU_EXTENSION_S
			-- New context menu extension service.
		deferred
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_tool_menu_extension_service: TOOL_MENU_EXTENSION_S
			-- New tool menu extension service.
		deferred
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_command_line_option_extension_service: COMMAND_LINE_OPTION_EXTENSION_S
		do
			Result := {REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION}
				.reif_ext_batch_service_initializer_extension
				.new_command_line_options_extension_service
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

end
