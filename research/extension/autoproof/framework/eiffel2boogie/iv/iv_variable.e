note
	description: "[
		TODO
	]"
	date: "$Date: 2012-05-10 22:58:31 +0800 (Thu, 10 May 2012) $"
	revision: "$Revision: 88710 $"

class
	IV_VARIABLE

inherit

	IV_DECLARATION

	IV_ENTITY_DECLARATION

create
	make

feature -- Visitor

	process (a_visitor: IV_UNIVERSE_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_variable (Current)
		end

end
