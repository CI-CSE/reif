note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"
	testing: "type/manual"

class
	TEST_TARGET_DATA

inherit
	EQA_TEST_SET

feature -- Test routines

	test_target_data_1
		local
			ctx: LLVM_CONTEXT
			module: MODULE
			t: TARGET_DATA
			i: INTEGER_TYPE
			s: NATURAL_64
		do
			create ctx
			create module.make ("test", ctx)
			create t.make_module (module)
			create i.make (ctx, 32)
			s := t.get_type_alloc_size (i)
			assert ("test_target_data_1", s = 4)
		end

	test_target_data_2
		local
			ctx: LLVM_CONTEXT
			module: MODULE
			t: TARGET_DATA
			i: INTEGER_TYPE
			s: NATURAL_64
		do
			create ctx
			create module.make ("test", ctx)
			create t.make_module (module)
			create i.make (ctx, 32)
			s := t.get_type_alloc_size_in_bits (i)
			assert ("test_target_data_2", s = 32)
		end

end


