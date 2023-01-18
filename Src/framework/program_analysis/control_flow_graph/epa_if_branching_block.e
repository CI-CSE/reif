note
	description: "Object that represents a if branching block in a CFG."
	author: ""
	date: "$Date: 2011-09-06 04:31:16 +0800 (Tue, 06 Sep 2011) $"
	revision: "$Revision: 87167 $"

class
	EPA_IF_BRANCHING_BLOCK

inherit
	EPA_BRANCHING_BLOCK
	-- 	redefine
	--		condition
	--	end

create
	make

feature {NONE} -- Initialization

	make (a_id: INTEGER; a_condition: like condition)
			-- Initialize Current.
		do
			set_id (a_id)
			condition := a_condition
			create asts.make (initial_capacity)
			asts.extend (condition)
			initialize_predecessors_and_successors
		end

feature -- Access

	condition: EXPR_AS
			-- Condition on which execution branches

feature -- Visitor

	process (a_visitor: EPA_CFG_BLOCK_VISITOR)
			-- Visitor feature.
		do
			a_visitor.process_if_branching_block (Current)
		end

end
