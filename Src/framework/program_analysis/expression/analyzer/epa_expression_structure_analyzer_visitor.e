note
	description: "Summary description for {AFX_EXPRESSION_STRUCTURE_ANALYZER_VISITOR}."
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

deferred class
	EPA_EXPRESSION_STRUCTURE_ANALYZER_VISITOR

feature -- Access

	process_abq_structure_analyzer (a_analyzer: EPA_ABQ_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

	process_abq_implication_structure_analyzer (a_analyzer: EPA_ABQ_IMPLICATION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

	process_linear_constrained_structure_analyzer (a_analyzer: EPA_LINEAR_CONSTRAINED_EXPRESSION_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

	process_any_structure_analyzer (a_analyzer: EPA_ANY_STRUCTURE_ANALYZER)
			-- Process `a_analyzer'.
		deferred
		end

end
