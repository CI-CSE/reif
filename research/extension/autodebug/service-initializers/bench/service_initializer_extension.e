class
	SERVICE_INITIALIZER_EXTENSION

inherit
	SERVICE_INITIALIZER
		undefine
			add_core_services
		end

	ADB_BATCH_SERVICE_INITIALIZER_EXTENSION
		redefine
			add_core_services
		end

feature

	add_core_services (c: SERVICE_CONTAINER_S)
		do
			Precursor {SERVICE_INITIALIZER} (c)
			Precursor {ADB_BATCH_SERVICE_INITIALIZER_EXTENSION} (c)
		end
end
