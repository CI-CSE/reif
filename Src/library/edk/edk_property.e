note
	description: "Summary description for {EDK_PROPERTY}."
	author: ""
	date: "$Date: 2009-06-27 09:55:57 +0800 (周六, 27 6月 2009) $"
	revision: "$Revision: 79490 $"

class
	EDK_PROPERTY

inherit
	ANY
		redefine
			default_create
		end


feature -- Initialization

	default_create
		do
			name := once ""
		end

feature -- Access

	name: IMMUTABLE_STRING_8
		-- Property name (set when properly registered)

	is_read_only: BOOLEAN
			-- Is `Current' read-only?
		do

		end

end
