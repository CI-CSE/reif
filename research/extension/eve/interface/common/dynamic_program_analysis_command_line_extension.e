note
	description: "Dynamic Program Analysis command-line extension"

class
	DYNAMIC_PROGRAM_ANALYSIS_COMMAND_LINE_EXTENSION


inherit
	COMMAND_LINE_OPTION_EXTENSION_S

	DISPOSABLE_SAFE

feature {NONE} -- Clean up

	safe_dispose (a_explicit: BOOLEAN)
			-- <Precursor>
		do
		end

feature

	argument_count (o: READABLE_STRING_32): like unknown_option
		do
			Result := if o ~ dynamic_program_analysis_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [dynamic_program_analysis_name] := "run dynamic program analysis"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_DYNAMIC_PROGRAM_ANALYSIS
		do
			create Result.make_with_arguments (a)
		end

	dynamic_program_analysis_name: STRING_32 = "dynamic_program_analysis"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end
end
