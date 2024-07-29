note
description: "AutoFix command-line extension"

class
	AUTO_FIX_COMMAND_LINE_EXTENSION

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
			Result := if o ~ auto_fix_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [auto_fix_name] := "run AutoFix"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_AUTO_FIX
		do
			create Result.make_with_arguments (a)
		end

	auto_fix_name: STRING_32 = "auto_fix"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
