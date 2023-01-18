note
	description: "Class holding information about the snippet's origin."
	date: "$Date: 2011-07-13 02:05:35 +0800 (Wed, 13 Jul 2011) $"
	revision: "$Revision: 86844 $"

class
	EXT_SNIPPET_ORIGIN

inherit
	ANY
		redefine
			out
		end

create
	make

feature {NONE} -- Initialization

	make (a_namespace, a_class_name, a_feature_name: STRING)
		require
			attached a_namespace and then not a_namespace.is_empty
			attached a_class_name and then not a_class_name.is_empty
			attached a_feature_name and then not a_feature_name.is_empty
		do
			namespace := a_namespace
			class_name := a_class_name
			feature_name := a_feature_name
		end

feature -- Access

	namespace: STRING

	class_name: STRING

	feature_name: STRING

feature -- Output

	out_separator: STRING = "."
			-- Separator used to create readable textual `out'.

	out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			create Result.make_empty
			Result.append (namespace)
			Result.append (out_separator)
			Result.append (class_name)
			Result.append (out_separator)
			Result.append (feature_name)
		end

end
