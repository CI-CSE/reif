note
	description: "Common ancestor class for AutoProof tests"
	testing: "type/manual"

class
	AP_TEST

inherit
	EQA_TEST_SET
		undefine
			assert
		end

	EQA_COMMONLY_USED_ASSERTIONS
		undefine
			default_create
		end
end
