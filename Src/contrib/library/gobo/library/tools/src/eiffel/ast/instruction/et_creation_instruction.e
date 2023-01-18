note

	description:

		"Eiffel creation instructions"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 1999-2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

deferred class ET_CREATION_INSTRUCTION

inherit

	ET_INSTRUCTION
		redefine
			reset
		end

	ET_CREATION_COMPONENT

feature -- Initialization

	reset
			-- Reset instruction as it was just after it was last parsed.
		do
			target.reset
			if attached type as l_type then
				l_type.reset
			end
			if attached creation_call as l_creation_call then
				l_creation_call.reset
			end
		end

feature -- Access

	target: ET_WRITABLE
			-- Target of the creation

	creation_call: detachable ET_QUALIFIED_CALL
			-- Call to creation procedure

	arguments: detachable ET_ACTUAL_ARGUMENT_LIST
			-- Arguments of creation call
		do
			if attached creation_call as l_creation_call then
				Result := l_creation_call.arguments
			end
		end

invariant

	target_not_void: target /= Void

end
