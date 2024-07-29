note
	description: "Boogie Verification command-line extension"

class
	BOOGIE_VERIFICATION_COMMAND_LINE_EXTENSION

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
			Result := if o ~ boogie_name or o ~ autoproof_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (2)
			Result [boogie_name] := "run autoproof verification (obsolete command, use"
				+ autoproof_name + " instead)"
			Result [autoproof_name] := "run autoproof verification"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_BOOGIE_VERIFICATION
		do
			create Result.make_with_arguments (a)
		end

	autoproof_name: STRING_32 = "autoproof"
	boogie_name: STRING_32 = "boogie"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
