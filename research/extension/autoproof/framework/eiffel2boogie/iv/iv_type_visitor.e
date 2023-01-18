note
	description: "[
		Visitor that processes Boogie types.
	]"
	date: "$Date: 2014-01-14 22:14:21 +0800 (Tue, 14 Jan 2014) $"
	revision: "$Revision: 93982 $"

deferred class
	IV_TYPE_VISITOR

feature -- Visitor

	process_boolean_type (a_type: IV_BASIC_TYPE)
			-- Process boolean type.
		deferred
		end

	process_integer_type (a_type: IV_BASIC_TYPE)
			-- Process integer type.
		deferred
		end

	process_real_type (a_type: IV_BASIC_TYPE)
			-- Process integer type.
		deferred
		end

	process_user_type (a_type: IV_USER_TYPE)
			-- Process user-defined type.
		deferred
		end

	process_variable_type (a_type: IV_VAR_TYPE)
			-- Process variable type.
		deferred
		end

	process_map_type (a_type: IV_MAP_TYPE)
			-- Process map type.
		deferred
		end

	process_map_synonym_type (a_type: IV_MAP_SYNONYM_TYPE)
			-- Process map type with synonym.
		deferred
		end

end
