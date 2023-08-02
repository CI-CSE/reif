note
	description: "Relation on a set."
	author: ""
	date: "$Date: 2010-10-01 22:01:07 +0800 (Fri, 01 Oct 2010) $"
	revision: "$Revision: 84470 $"

deferred class
	MML_ENDORELATION [G->ANY]

inherit
	MML_RELATION [G, G]


feature -- Status report
	reflexive: BOOLEAN
			-- Is relation reflexive?
		deferred
		end

	irreflexive: BOOLEAN
			-- Is relation irreflexive?
		deferred
		end

	symmetric: BOOLEAN
			-- Is relation symmetric?
		deferred
		end

	antisymmetric: BOOLEAN
			-- Is relation antisymmetric?
		deferred
		end

	transitive: BOOLEAN
			-- Is relation transitive?
		deferred
		end

	total: BOOLEAN
			-- Is relation total?
		deferred
		end
end
