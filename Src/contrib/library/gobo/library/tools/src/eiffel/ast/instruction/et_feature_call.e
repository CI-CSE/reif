note

	description:

		"Eiffel feature calls"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2004-2016, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2017-04-12 02:34:55 +0800 (周三, 12 4月 2017) $"
	revision: "$Revision: 100137 $"

deferred class ET_FEATURE_CALL

inherit

	ET_CALL_COMPONENT
		redefine
			target, arguments
		end

	ET_CALL_WITH_ACTUAL_ARGUMENTS
		redefine
			arguments
		end

feature -- Access

	target: detachable ET_EXPRESSION
			-- Target
		deferred
		end

	arguments: detachable ET_ACTUAL_ARGUMENTS
			-- Arguments
		deferred
		end

	parenthesis_call: detachable ET_PARENTHESIS_CALL
			-- Unfolded form when the current call is of the parenthesis alias form;
			-- For example, if the current call is 'f (args)', its parenthesis call
			-- will be 'f.g (args)' where 'g' is declared as 'g alias "()"'.
		do
		end

end
