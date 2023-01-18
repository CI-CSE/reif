note
	description: "Deferred implementation for classes that work with {EXT_HOLE_FACTORY}."
	date: "$Date: 2011-07-09 02:25:37 +0800 (Sat, 09 Jul 2011) $"
	revision: "$Revision: 86829 $"

deferred class
	EXT_HOLE_FACTORY_AWARE

feature {NONE} -- Implementation

	hole_factory: EXT_HOLE_FACTORY
			-- Hole factory to create new instances with distinct identifiers.

end
