class
	ADB_BATCH_SERVICE_INITIALIZER_EXTENSION

inherit
	AP_BATCH_SERVICE_INITIALIZER_EXTENSION
		redefine
			cli_option_extensions
		end

feature
	cli_option_extensions: ARRAYED_LIST [COMMAND_LINE_OPTION_EXTENSION_S]
		do
			Result := Precursor
			Result.extend (create {CONTRACT_INFERENCE_COMMAND_LINE_EXTENSION})
		end
end
