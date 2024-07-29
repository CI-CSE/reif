note
	description: "Contract Inference command-line extension"

class
	CONTRACT_INFERENCE_COMMAND_LINE_EXTENSION


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
			Result := if o ~ contract_inference_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [contract_inference_name] := "run contract inference"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_CONTRACT_INFERENCE
		do
			create Result.make_with_arguments (a)
		end

	contract_inference_name: STRING_32 = "contract_inference"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end

end
