note
	description: "Annotation command-line extension"

class
	ANNOTATION_COMMAND_LINE_EXTENSION


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
			Result := if o ~ annotation_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [annotation_name] := "run annotation"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_ANNOTATION
		do
			create Result.make_with_arguments (a)
		end

	annotation_name: STRING_32 = "annotation"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
