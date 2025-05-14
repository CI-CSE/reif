note
	description: "Batch ES with Reif command line extension service loaded"

class
	REIF_BATCH

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
				l_service.register_with_activator ({ROTA_S}, agent new_rota, False)

				{REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION}
					.reif_ext_batch_service_initializer_extension
					.add_core_services (l_service)
			end
		end

feature {NONE}

	new_rota: TTY_ROTA
		do
			create Result.make
		end

end
