note
	description: "Summary description for {AFX_ACCESS_RESULT}."
	author: ""
	date: "$Date: 2010-06-25 19:15:55 +0800 (Fri, 25 Jun 2010) $"
	revision: "$Revision: 83700 $"

class
	EPA_ACCESS_RESULT

inherit
	EPA_ACCESS
		rename
			make_with_class_feature as make
		redefine
			is_result--,
			-- length
		end

create
	make

feature -- Access

	type: TYPE_A
			-- Type of current access
		do
			Result :=
				actual_type_from_formal_type (
					context_feature.type.instantiation_in (context_class.actual_type, context_class.class_id).actual_type,
					context_class)
		end

	text: STRING
			-- Text of current access
		do
			Result := once "Result"
		ensure then
			good_result: Result.is_equal ("Result")
		end

	length: INTEGER = 1
			-- Length of current access

feature -- Status report

	is_result: BOOLEAN = True
			-- Is current access a result?

end
