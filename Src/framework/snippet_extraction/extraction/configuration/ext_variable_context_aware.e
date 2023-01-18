note
	description: "Deferred implementation for classes that work with {EXT_VARIABLE_CONTEXT}."
	date: "$Date: 2011-07-09 02:25:37 +0800 (Sat, 09 Jul 2011) $"
	revision: "$Revision: 86829 $"

deferred class
	EXT_VARIABLE_CONTEXT_AWARE

feature {NONE} -- Implementation

	variable_context: EXT_VARIABLE_CONTEXT
			-- Contextual information about relevant variables.

end
