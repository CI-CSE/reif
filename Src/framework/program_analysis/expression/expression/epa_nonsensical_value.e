note
	description: "Summary description for {AFX_NON_SENSICAL_VALUE}."
	author: ""
	date: "$Date: 2010-06-25 19:15:55 +0800 (Fri, 25 Jun 2010) $"
	revision: "$Revision: 83700 $"

class
	EPA_NONSENSICAL_VALUE

inherit
	EPA_EXPRESSION_VALUE
		redefine
			is_nonsensical,
			as_nonsensical
		end

	ITP_SHARED_CONSTANTS
		undefine
			is_equal,
			copy,
			out
		end

feature -- Access

	type: TYPE_A
			-- Type of current value
		do
			Result := none_type
		end

	item: STRING
			-- Value item in current
		do
			Result := nonsensical_value
		end

	as_nonsensical: detachable EPA_NONSENSICAL_VALUE
			-- Current as nonsensical value
		do
			Result := Current
		end

feature -- Status report

	is_nonsensical: BOOLEAN = True
			-- Is current a nonsensical value?

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_nonsensical_value (Current)
		end

end
