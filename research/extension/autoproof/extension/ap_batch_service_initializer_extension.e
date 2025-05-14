class
	AP_BATCH_SERVICE_INITIALIZER_EXTENSION

inherit
	REIF_EXT_BATCH_SERVICE_INITIALIZER_EXTENSION
		redefine
			cli_option_extensions
		end

feature

	cli_option_extensions: ARRAYED_LIST [COMMAND_LINE_OPTION_EXTENSION_S]
		do
			Result := Precursor
			Result.extend (create {BOOGIE_VERIFICATION_COMMAND_LINE_EXTENSION}.make (agent ({ES}.command_line_io).output_window))
			Result.extend (create {AP_COMMAND_LINE_OPTION_EXTENSION}.make (agent ({ES}.command_line_io).output_window))
		end

end
