note

	description:

		"Shared decimal math constants"

	library: "Gobo Eiffel Decimal Arithmetic Library"
	copyright: "Copyright (c) 2005-2018, Paul G. Crismer and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class MA_SHARED_DECIMAL_CONSTANTS

feature -- Access

	decimal: MA_DECIMAL_CONSTANTS
			-- Decimal constants
		once
			create Result
		ensure
			instance_free: class
			decimal_not_void: Result /= Void
		end

end
