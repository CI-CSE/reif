note
	description: "Class represents queries to the information retrieval system"
	date: "$Date: 2010-10-11 05:45:56 +0800 (Mon, 11 Oct 2010) $"
	revision: "$Revision: 84547 $"

deferred class
	IR_QUERY

inherit
	KL_SHARED_STRING_EQUALITY_TESTER

feature -- Access

	returned_fields: DS_HASH_SET [STRING]
			-- Names of fields that are to be returned by the query
		do
			if returned_fields_internal = Void then
				create returned_fields_internal.make (20)
				returned_fields_internal.set_equality_tester (string_equality_tester)
			end
			Result := returned_fields_internal
		end

	meta: HASH_TABLE [STRING, STRING]
			-- Table of meta data, such as query time, query status code
			-- Key is data name, value is data value
		do
			if meta_internal = Void then
				create meta_internal.make (10)
				meta_internal.compare_objects
			end
			Result := meta_internal
		end

feature -- Process

	process (a_visitor: IR_QUERY_VISITOR)
			-- Process Current using `a_visitor'.
		deferred
		end

feature{NONE} -- Implementation

	returned_fields_internal: detachable like returned_fields
			-- Cache for `returned_fields'

	meta_internal: detachable like meta
			-- Cache for `meta'

end
