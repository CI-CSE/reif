note
	description: "JavaScript Compilation command-line extension"

class
	JAVASCRIPT_COMPILATION_COMMAND_LINE_EXTENSION

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
			Result := if o ~ js_compile_name then
				0
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [js_compile_name] := "compile into JavaScript"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_JAVASCRIPT_COMPILATION
		do
			create Result
		end

	js_compile_name: STRING_32 = "js_compile"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
