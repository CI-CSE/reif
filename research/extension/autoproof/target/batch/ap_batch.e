note
	description: "ES from TTY with AutoProof services initialized"

class
	AP_BATCH

inherit
	ES
		redefine
			initialize
		end

create
	make

feature {NONE}

	initialize
		do
			Precursor {ES}
			initialize_services
		end

	initialize_services
			-- Initializes tty services
		local
			l_container: SERVICE_CONSUMER [SERVICE_CONTAINER_S]
		do
			create l_container
			check attached l_container.service as l_service then
				l_service.register_with_activator (
					{COMMAND_LINE_OPTION_EXTENSION_S}, agent new_cl_ext, False)
				l_service.register_with_activator (
					{ROTA_S}, agent new_rota, False)
			end
		end

	new_cl_ext: EC_COMMAND_LINE_OPTION_EXTENSION
		do
			create Result.make (agent command_line_io.output_window)
		end

	new_rota: TTY_ROTA
		do
			create Result.make
		end

end
