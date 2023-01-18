note

	description:

		"Eiffel feature call expressions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2005-2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

deferred class ET_FEATURE_CALL_EXPRESSION

inherit

	ET_FEATURE_CALL
		redefine
			parenthesis_call
		end

	ET_EXPRESSION
		undefine
			is_instance_free
		end

feature -- Access

	parenthesis_call: detachable ET_PARENTHESIS_EXPRESSION
			-- <Precursor>
		do
		end

end
