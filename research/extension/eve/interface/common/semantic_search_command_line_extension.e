note
	description: "Semantic Search command-line extension"

class
	SEMANTIC_SEARCH_COMMAND_LINE_EXTENSION

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
			Result := if o ~ semantic_search_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [semantic_search_name] := "run semantic search"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_SEMANTIC_SEARCH
		do
			create Result.make_with_arguments (a)
		end

	semantic_search_name: STRING_32 = "semantic_search"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
