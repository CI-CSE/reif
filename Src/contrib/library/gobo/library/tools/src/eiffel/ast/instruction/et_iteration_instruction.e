note

	description:
	"[
		Eiffel iteration instructions (either across instructions,
		or repeat instructions).
	]"
	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2020-01-08 18:24:11 +0800 (周三, 08 1月 2020) $"
	revision: "$Revision: 103831 $"

deferred class ET_ITERATION_INSTRUCTION

inherit

	ET_ITERATION_COMPONENT
		redefine
			reset
		end

	ET_INSTRUCTION
		redefine
			reset
		end

	ET_LOOP_COMPONENT

feature -- Initialization

	reset
			-- Reset instruction as it was just after it was last parsed.
		do
			if attached from_compound as l_from_compound then
				l_from_compound.reset
			end
			if attached loop_compound as l_loop_compound then
				l_loop_compound.reset
			end
			precursor {ET_ITERATION_COMPONENT}
		end

end
