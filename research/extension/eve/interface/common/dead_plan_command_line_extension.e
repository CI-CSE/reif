note
description: "Dead Plan command-line extension"

class
DEAD_PLAN_COMMAND_LINE_EXTENSION

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
			Result := if o ~ dead_plan_name then
				2
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [dead_plan_name] := "run dead plan"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_DEAD_PLAN
		do
			create Result.make (a [1], a [2])
		end

	dead_plan_name: STRING_32 = "dead_plan"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
