note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"
	testing: "type/manual"

class
	TEST_MEM_SET_INST

inherit
	EQA_TEST_SET

feature -- Test routines

	test_mem_set_inst_1
		local
			ctx: LLVM_CONTEXT
			module: MODULE
			m: MEM_SET_INST
		do
			create ctx
			create module.make ("test", ctx)
		end

end


