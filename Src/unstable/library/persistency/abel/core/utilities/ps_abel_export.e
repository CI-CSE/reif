note
	description: "Dummy class to restrict export of internal features."
	author: "Roman schmocker"
	date: "$Date: 2014-01-03 09:59:54 +0800 (周五, 03 1月 2014) $"
	revision: "$Revision: 93884 $"

class
	PS_ABEL_EXPORT

inherit

	REFACTORING_HELPER
		export {NONE}
			--to_implement_assertion,
			fixme,
			to_implement
		end
end
