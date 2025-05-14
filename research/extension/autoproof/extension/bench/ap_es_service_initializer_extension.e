note
	description: "Initialize AutoProof extensions"

class
	AP_ES_SERVICE_INITIALIZER_EXTENSION

inherit
	REIF_EXT_ES_SERVICE_INITIALIZER_EXTENSION
		redefine
			add_core_services
		end

feature -- Services

	add_core_services (c: SERVICE_CONTAINER_S)
			-- <Precursor>
		do
			Precursor (c)

			c.register_with_activator ({VERIFIER_S}, agent new_verifier_service, False)
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
			create {AP_ES_CONTEXT_MENU_EXTENSION} Result
		end

	new_tool_menu_extension_service: TOOL_MENU_EXTENSION_S
			-- New tool menu extension service.
		do
			create {AP_ES_TOOL_MENU_EXTENSION} Result
		end
end
