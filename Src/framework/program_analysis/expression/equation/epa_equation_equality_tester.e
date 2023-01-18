note
	description: "Equality tester for {EPA_EQUATION} objects"
	author: ""
	date: "$Date: 2010-05-30 20:18:34 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83374 $"

class
	EPA_EQUATION_EQUALITY_TESTER

inherit
	KL_EQUALITY_TESTER [EPA_EQUATION]
		redefine
			test
		end

feature -- Status report

	test (v, u: EPA_EQUATION): BOOLEAN
		do
			if v = u then
				Result := True
			elseif v = Void then
				Result := False
			elseif u = Void then
				Result := False
			else
				Result :=
					expression_equality_tester.test (u.expression, v.expression) and then
					value_equality_tester.test (u.value, v.value)
			end
		end

feature{NONE} -- Implementation

	expression_equality_tester: EPA_EXPRESSION_EQUALITY_TESTER
			-- Equality tester for expressions
		once
			create Result
		end

	value_equality_tester: EPA_EXPRESSION_VALUE_EQUALITY_TESTER
			-- Equality tester for expression values
		once
			create Result
		end


end
