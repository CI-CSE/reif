note
	description: "Enum value for policy strength (default, global, local)."
	author: "Paolo Antonucci"
	date: "$Date: 2014-08-27 23:30:17 +0800 (Wed, 27 Aug 2014) $"
	revision: "$Revision: 95706 $"

expanded class
	AT_POLICY_STRENGTH

inherit

	AT_ENUM_VALUE
		-- redefine
		--	enum_type
		-- end

create
	default_create, make_with_numerical_value, make_with_value_name

feature -- Enum type

	enum_type: AT_ENUM_POLICY_STRENGTH
			-- <Precursor>
		once ("PROCESS")
			create Result
		end

end
