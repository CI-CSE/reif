note
	description: "[
		Eiffel tests that can be executed by testing tool.
	]"
	author: "EiffelStudio test wizard"
	date: "$Date: 2014-01-25 08:02:12 +0800 (周六, 25 1月 2014) $"
	revision: "$Revision: 94100 $"
	testing: "type/manual"

class
	TEST_DBG_DECLARE

inherit
	EQA_TEST_SET

feature -- Test routines

	test_dbg_declare_1
		local
			ctx: LLVM_CONTEXT
			m: MODULE
			d: DBG_DECLARE
			s: RAW_STRING_OSTREAM
			s_result: STRING
		do
			create ctx
			create m.make ("test", ctx)
			create d.make (ctx, m)
			create s.make
			m.print (s)
			s_result := s.string
		end

	test_dbg_declare_1_expected: STRING_8 =
"[
; ModuleID = 'test'

declare void @llvm.dbg.declare(metadata, metadata) nounwind readnone

]"

end


