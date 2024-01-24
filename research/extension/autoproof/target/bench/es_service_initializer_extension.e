note
	description: "Initialize AutoProof extensions"

class
	ES_SERVICE_INITIALIZER_EXTENSION

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

			-- AutoProof
			c.register_with_activator ({VERIFIER_S}, agent new_verifier_service, False)


			-- EVE or Common
			c.register_with_activator ({CONTEXT_MENU_EXTENSION_S}, agent new_context_menu_extension_service, False)
			c.register_with_activator ({TOOL_MENU_EXTENSION_S}, agent new_tool_menu_extension_service, False)
		end

feature {NONE} -- Factory

	new_verifier_service: VERIFIER_S
			-- New verifier service.
		do
			create {ES_AUTOPROOF_VERIFIER} Result
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_context_menu_extension_service: CONTEXT_MENU_EXTENSION_S
			-- New context menu extension service.
		do
			create {ES_CONTEXT_MENU_EXTENSION} Result
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_tool_menu_extension_service: TOOL_MENU_EXTENSION_S
			-- New tool menu extension service.
		do
			create {ES_TOOL_MENU_EXTENSION} Result
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end
end
