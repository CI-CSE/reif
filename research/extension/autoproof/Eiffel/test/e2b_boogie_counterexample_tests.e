note
	description: "Tests for E2B_BOOGIE_COUNTEREXAMPLE"
	testing: "type/manual"

class
	E2B_BOOGIE_COUNTEREXAMPLE_TESTS

inherit
	AP_TEST

feature
	test_parse_names
		local
			name1_str, name2_str: STRING
			res: like {E2B_BOOGIE_COUNTEREXAMPLE}.parse_names
		do
			name1_str := "a -> b"
			name2_str := "x -> y"
			res := {E2B_BOOGIE_COUNTEREXAMPLE}.parse_names(
				name1_str + "%N" + name2_str + "%N" + "extra -> {")

			assert_equal ("Two names extracted", 2, res.names.count)
			assert_strings_equal ("First name correct", "b", res.names ["a"])
			assert_strings_equal ("Second name correct", "y", res.names ["x"])
			assert_equal ("Consumed only two lines",
				name1_str.count + 1 + name2_str.count + 1,
				res.consumed
			)
		end

	test_parse_functions
		local
			res: like {E2B_BOOGIE_COUNTEREXAMPLE}.parse_functions
			functions: HASH_TABLE [LIST [TUPLE [args: detachable LIST [STRING]; res: STRING]], STRING]
			item: LIST [TUPLE [args: detachable LIST [STRING]; res: STRING]]
		do
			res := {E2B_BOOGIE_COUNTEREXAMPLE}.parse_functions("[
				abs_real -> {
					else -> 0.0
				}
				attached -> {
					T@U!val!12 T@U!val!13 T@U!val!6 -> true
					else -> true
				}
			]")
			functions := res.functions

			assert_arrays_equal ("Has all functions as keys",
				<< "abs_real", "attached" >>,
				functions.current_keys)

			item := functions ["abs_real"]
			assert ("abs_real is one [Void -> 0.0] case",
				item.count = 1
					and then item.first.args = Void
					and then item.first.res ~ "0.0")

			item := functions ["attached"]
			assert_equal ("attached is two cases", 2, item.count)
			assert ("attached first case is with arguments",
				item.first.args.count = 3
					and then item.first.args [1] ~ "T@U!val!12"
					and then item.first.args [2] ~ "T@U!val!13"
					and then item.first.args [3] ~ "T@U!val!6"
					and then item.first.res ~ "true"
			)
			assert ("attached second case is without arguments",
				item.last.args = Void
				and then item.last.res ~ "true"
			)
		end

	test_apply_function
		local
			ce: E2B_BOOGIE_COUNTEREXAMPLE
		do
			create ce.make ("[
				*** MODEL
				f -> {
					a b c -> 1
					x y z -> 2
					else -> 3
				}
				*** STATE A.f
			]")
			assert_strings_equal ("Returns correct result", "1",
				ce.apply_function ("f", create {ARRAYED_LIST [STRING]}.make_from_array(
					<< "a", "b", "c" >>)))
		end


	test_make
		local
			ce: E2B_BOOGIE_COUNTEREXAMPLE
		do
			create ce.make ("[
				*** MODEL
				Void -> 1
				a -> 10
				b -> 10
				f -> {
					else -> 0
				}
				*** STATE C.a
			]")

			assert_strings_equal ("Has name to raw", "1", ce.name_to_raw ["Void"])
			assert_strings_equal ("Has raw to name", "Void", ce.raw_to_name ["1"].first)
			assert_equal ("Has both aliases of 10", 2, ce.raw_to_name ["10"].count)
			ce.raw_to_name ["10"].compare_objects
			assert ("Has first alias name", ce.raw_to_name ["10"].has ("a"))
			assert ("Has second alias name", ce.raw_to_name ["10"].has ("b"))
			assert_equal ("Has functions", 1, ce.functions.count)
			assert_strings_equal ("Has class_name", "C", ce.class_name)
			assert_strings_equal ("Has routine_name", "a", ce.routine_name)
		end

end
