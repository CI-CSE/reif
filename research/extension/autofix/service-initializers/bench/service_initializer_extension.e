class
	SERVICE_INITIALIZER_EXTENSION

inherit
	SERVICE_INITIALIZER
		undefine
			add_core_services
		end

	AP_BATCH_SERVICE_INITIALIZER_EXTENSION
		redefine
			add_core_services
		end

feature

	add_core_services (c: SERVICE_CONTAINER_S)
		do
			Precursor {SERVICE_INITIALIZER} (c)
			Precursor {AP_BATCH_SERVICE_INITIALIZER_EXTENSION} (c)
		end
end
