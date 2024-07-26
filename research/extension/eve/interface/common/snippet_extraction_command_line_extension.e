note
	description: "Snippet Extraction command-line extension"

class
	SNIPPET_EXTRACTION_COMMAND_LINE_EXTENSION

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
			Result := if o ~ snippet_extraction_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [snippet_extraction_name] := "run snippet extraction"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_SNIPPET_EXTRACTION
		do
			create Result.make_with_arguments (a)
		end

	snippet_extraction_name: STRING_32 = "snippet_extraction"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
