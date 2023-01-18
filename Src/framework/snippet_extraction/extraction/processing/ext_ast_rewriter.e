note
	description: "Interface for rewriting ASTs."
	date: "$Date: 2012-01-19 07:49:03 +0800 (Thu, 19 Jan 2012) $"
	revision: "$Revision: 88202 $"

deferred class
	EXT_AST_REWRITER [G -> AST_EIFFEL]

feature -- Access

	last_ast: detachable G
			-- AST transfomed by last `rewrite'.

feature -- Basic operations

	rewrite (a_ast: G)
			-- Rewrites `a_ast' and makes the
			-- result available in `last_ast'.
		deferred
		end

end
