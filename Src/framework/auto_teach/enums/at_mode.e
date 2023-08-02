note
	description: "Enum value for AutoTeach modes (auto, manual, custom)."
	author: "Paolo Antonucci"
	date: "$Date: 2014-08-21 23:16:22 +0800 (Thu, 21 Aug 2014) $"
	revision: "$Revision: 95690 $"

expanded class
	AT_MODE

inherit

	AT_ENUM_VALUE
		--redefine
		--	enum_type
		--end

create
	default_create, make_with_numerical_value, make_with_value_name

feature -- Enum type

	enum_type: AT_ENUM_MODE
			-- <Precursor>
		once ("PROCESS")
			create Result
		end

end
