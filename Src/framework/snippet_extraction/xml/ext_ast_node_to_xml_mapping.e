note
	description: "Mapping from AST constants to XML Schema element names."
	date: "$Date: 2012-01-19 07:49:03 +0800 (Thu, 19 Jan 2012) $"
	revision: "$Revision: 88202 $"

class
	EXT_AST_NODE_TO_XML_MAPPING

inherit
	EXT_AST_NODE_CONSTANTS

feature -- Mapping

	ast_node_to_xml_tag (a_node_name: STRING): STRING
			-- Transform `a_node_name' to lower case.
			-- Generic nodes names are modified to not include brackets.		
		do
			create Result.make_from_string (a_node_name)

			Result.to_lower

			Result.replace_substring_all (" ", "_of_")
			Result.replace_substring_all ("[", "")
			Result.replace_substring_all ("]", "")
		end

	ast_node_to_xml_tag_type (a_node_name: STRING): STRING
			-- Append a postfix to `ast_node_to_xml_tag' denoting the corresponding XML Schema type.
		do
			Result := ast_node_to_xml_tag (a_node_name)
			Result.append ("_TYPE")
		end

	ast_node_to_xml_tag_group (a_node_name: STRING): STRING
			-- Append a postfix to `ast_node_to_xml_tag' denoting the corresponding XML Schema group.		
		do
			Result := ast_node_to_xml_tag (a_node_name)
			Result.append ("_GROUP")
		end

end
