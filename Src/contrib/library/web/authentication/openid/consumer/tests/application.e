note
	description : "Objects that ..."
	author      : "$Author: jfiat $"
	date        : "$Date: 2013-05-20 21:34:55 +0800 (周一, 20 5月 2013) $"
	revision    : "$Revision: 92549 $"

class
	APPLICATION

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Initialize `Current'.
		do
			test_openid
		end

	test_openid
		local
			t: TEST_OPENID
		do
			create t.make
		end

end
