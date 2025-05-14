note
	description: "Reif command line extension service initializer"

class
	REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION

feature
	add_core_services (c: SERVICE_CONTAINER_S)
			-- <Precursor>
		do
			c.register_with_activator ({ROTA_S}, agent new_rota, False)
			c.register_with_activator ({COMMAND_LINE_OPTION_EXTENSION_S}, agent new_command_line_options_extension_service, False)
		end

	reif_ext_batch_service_initializer_extension: attached REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION
			-- Initializer used to register all services.
		local
			t: like {REFLECTOR}.dynamic_type_from_string
		once
			t := {REFLECTOR}.dynamic_type_from_string ("BATCH_SERVICE_INITIALIZER_EXTENSION")
			if t < 0 then
				(create {EXCEPTIONS}).raise ("Class BATCH_SERVICE_INITIALIZER_EXTENSION not found. Make sure it is in the target.")
			end
			if {REFLECTOR}.type_of_type (t).is_deferred then
				(create {EXCEPTIONS}).raise ("Class BATCH_SERVICE_INITIALIZER_EXTENSION is deferred. Make sure it is effective.")
			end
			if attached {REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION} {REFLECTOR}.new_instance_of (t) as e then
				Result := e
			else
				(create {EXCEPTIONS}).raise ("Class BATCH_SERVICE_INITIALIZER_EXTENSION does not inherit from REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION. Make sure it inherits from it.")
			end
		ensure
			instance_free: class
		end

	cli_option_extensions: ARRAYED_LIST [COMMAND_LINE_OPTION_EXTENSION_S]
			-- CLI Option extensions to be used
		do
			create Result.make (0)
		end

feature {NONE}

	new_rota: TTY_ROTA
		do
			create Result.make
		end

feature {REIF_EXT_ES_SERVICE_INITIALIZER_EXTENSION}

	new_command_line_options_extension_service: REIF_EXT_CLI_OPTION_EXTENSION_S
			-- Command line option extension.
			-- Used for both `batch` and `bench` targets
		do
			create Result.make (cli_option_extensions)
		end

end
