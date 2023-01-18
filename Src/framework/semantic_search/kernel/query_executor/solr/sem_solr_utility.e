note
	description: "Solr utilities"
	author: ""
	date: "$Date: 2010-10-11 05:45:56 +0800 (Mon, 11 Oct 2010) $"
	revision: "$Revision: 84547 $"

class
	SEM_SOLR_UTILITY

inherit
	SEM_CONSTANTS

feature -- Access

	field_name_prefix_for_term (a_term: SEM_TERM; a_type_form: INTEGER; a_meta: BOOLEAN): STRING
			-- Prefix for `a_term' in `a_type_form'
		require
			a_type_form_valid: is_type_form_valid (a_type_form)
		do
			Result := field_prefix_generator.term_prefix (a_term, a_type_form, a_meta)
		end

end
