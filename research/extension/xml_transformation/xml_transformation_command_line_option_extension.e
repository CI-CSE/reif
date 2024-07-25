note
	description: "XML transformation command-line option extension"

class
	XML_TRANSFORMATION_COMMAND_LINE_OPTION_EXTENSION

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
			Result := if o ~ to_xml_name then
				all_arguments
			else
				unknown_option
			end
		end

	help: STRING_TABLE [READABLE_STRING_32]
		once
			create Result.make (1)
			Result [to_xml_name] := "get class AST in XML format"
		end

	command (o: READABLE_STRING_32; a: LIST [READABLE_STRING_32]): EWB_XML_TRANSFORMATION
		do
			create Result.make_with_arguments (a)
		end

	to_xml_name: STRING_32 = "to_xml"

	error: detachable READABLE_STRING_32
		do
			-- No errors
		end
end
