note
	description: "A rule that looks at some AST nodes. The rule will be checked using {CA_ALL_RULES_CHECKER}."
	author: "Stefan Zurfluh"
	date: "$Date: 2015-12-18 23:59:40 +0800 (周五, 18 12月 2015) $"
	revision: "$Revision: 98292 $"

deferred class
	CA_STANDARD_RULE

inherit
	CA_RULE

feature -- Activation

	frozen prepare_checking (a_checker: attached CA_ALL_RULES_CHECKER)
			-- Prepares this rule for being checked using `a_checker'.
		do
			violations.wipe_out
			register_actions (a_checker)
		end

feature {NONE} -- Implementation

	register_actions (a_checker: attached CA_ALL_RULES_CHECKER)
			-- Registers the agents that will be called during the AST visit with
			-- `a_checker'.
		deferred
		end

invariant
	title_set: title.count > 3
end
