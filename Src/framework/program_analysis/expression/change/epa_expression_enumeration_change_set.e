note
	description: "Class that represents a change set, whose elements are specified by enumerating all possible values"
	author: ""
	date: "$Date: 2010-10-05 05:07:18 +0800 (Tue, 05 Oct 2010) $"
	revision: "$Revision: 84497 $"

class
	EPA_EXPRESSION_ENUMERATION_CHANGE_SET

inherit
	EPA_EXPRESSION_CHANGE_VALUE_SET
		redefine
			is_enumeration
		end

create
	make

feature -- Status report

	is_enumeration: BOOLEAN = True
			-- Does Current represent an enumeration of values?

end
