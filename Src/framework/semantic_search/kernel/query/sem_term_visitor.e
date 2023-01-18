note
	description: "Visitor for {SEM_TERM}s"
	author: ""
	date: "$Date: 2010-10-27 04:51:36 +0800 (Wed, 27 Oct 2010) $"
	revision: "$Revision: 84720 $"

deferred class
	SEM_TERM_VISITOR

feature -- Process

	process_change_term (a_term: SEM_CHANGE_TERM)
			-- Process `a_term'.
		deferred
		end

	process_contract_term (a_term: SEM_CONTRACT_TERM)
			-- Process `a_term'.
		deferred
		end

	process_property_term (a_term: SEM_PROPERTY_TERM)
			-- Process `a_term'.
		deferred
		end

	process_variable_term (a_term: SEM_VARIABLE_TERM)
			-- Process `a_term'.
		deferred
		end

	process_variable_position_term (a_term: SEM_VARIABLE_POSITION_TERM)
			-- Process `a_term'.
		deferred
		end

end
