note
	description: "Command-line extension for AutoProof"

class
	REIF_EXT_CLI_OPTION_EXTENSION_S

inherit
	COMMAND_LINE_OPTION_EXTENSION_S

	DISPOSABLE_SAFE

create
	make

feature {NONE} -- Clean up

	safe_dispose (a_explicit: BOOLEAN)
			-- <Precursor>
		do
		end

feature

	make (a_extensions: ARRAYED_LIST [COMMAND_LINE_OPTION_EXTENSION_S])
		do
			extensions := a_extensions
		end

	extensions: ARRAYED_LIST [COMMAND_LINE_OPTION_EXTENSION_S]
			-- Individual tool extensions

	argument_count (o: READABLE_STRING_32): like unknown_option
		-- <Precursor>
		do
			Result := unknown_option
			across extensions as ext until Result /= unknown_option loop
				Result := ext.argument_count (o)
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
			-- <Precursor>
		once
			create Result.make (0)
			across extensions as ext loop
				Result.merge (ext.help)
			end
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): detachable E_CMD
			-- <Precursor>
		local
			handler: COMMAND_LINE_OPTION_EXTENSION_S
		do
			across extensions as ext until handler /= Void loop
				if ext.argument_count (o) /= unknown_option then
					handler := ext
				end
			end

			Result := handler.command (o, a)
			error := handler.error
		end

	error: detachable READABLE_STRING_32
			-- <Precursor>
end
