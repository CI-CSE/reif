note
	description: "Summary description for {MML_AGENT_ENDORELATION}."
	author: ""
	date: "$Date: 2010-10-01 22:01:07 +0800 (Fri, 01 Oct 2010) $"
	revision: "$Revision: 84470 $"

class
	MML_AGENT_ENDORELATION [G->ANY]

inherit
	MML_ENDORELATION [G]

	MML_AGENT_RELATION [G, G]

create
	such_that

feature -- Status report
	reflexive: BOOLEAN
			-- Is relation reflexive?
		do
		end

	irreflexive: BOOLEAN
			-- Is relation irreflexive?
		do
		end

	symmetric: BOOLEAN
			-- Is relation symmetric?
		do
		end

	antisymmetric: BOOLEAN
			-- Is relation antisymmetric?
		do
		end

	transitive: BOOLEAN
			-- Is relation transitive?
		do
		end

	total: BOOLEAN
			-- Is relation total?
		do
		end
end
