note
	description: "Representation of expression nodes referencing a binary operator."
	date: "$Date: 2015-05-30 03:38:29 +0800 (周六, 30 5月 2015) $"
	revision: "$Revision: 97409 $"

class
	BINARY_EXPR_AST

inherit
	EXPR_AST

create
	make

feature {NONE} -- Initialization

	make (a_op: CHARACTER; a_lhs, a_rhs: EXPR_AST)
			-- Initialize Current with `a_op' as `operator', `a_lhs' as `left' and `a_rhs' as `right'.
		do
			-- Left non-implemented in Chapter 1.
		end

end
