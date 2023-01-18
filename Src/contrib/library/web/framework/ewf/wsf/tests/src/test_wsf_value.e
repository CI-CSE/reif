note
	description: "Summary description for {TEST_WSF_VALUE}."
	author: ""
	date: "$Date: 2013-05-20 21:34:55 +0800 (周一, 20 5月 2013) $"
	revision: "$Revision: 92549 $"

class
	TEST_WSF_VALUE

inherit
	EQA_TEST_SET

feature {NONE} -- Events

	test_table
		local
			tb: WSF_TABLE
		do
			create tb.make ("table")
			assert ("Ok", True)
		end

end
