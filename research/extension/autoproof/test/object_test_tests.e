note
	description: "Tests for object test"
	testing: "autoproof", "type/manual", "execution/isolated"
class
	OBJECT_TEST_TESTS
inherit
	AP_TEST_EXAMPLES
feature
	boxing_in_object_test
		local
			formatter: STRING_TEXT_FORMATTER
		do
			print_file ("demo.e", "[
class
	DEMO
create
	make

feature
	make
		do
		end

	demo
		local
			a1, a2: ANY
			b: BOOLEAN
			i: INTEGER
		do
			b := False
			a1 := True
			a2 := b

			if attached {BOOLEAN} a1 as l_b1 and attached {BOOLEAN} a2 as l_b2 then
				check l_b1 end
				check not l_b2 end
			else
				check unreachable: False end
			end

			i := 17
			a1 := 4
			a2 := i

			if attached {INTEGER} a1 as l_i1 and attached {INTEGER} a2 as l_i2 then
				check l_i1 = 4 end
				check l_i2 = 17 end
			else
				check unreachable: False end
			end
			check has_to_fail: False end
		end
end
			]")
			print_ecf ("DEMO")
			command.add_feature ("demo", "DEMO")

			verify

			check
				attached {E2B_FAILED_VERIFICATION} result_of_feature ("demo", "qualified") as r
			then
				assert_equal ("One error", 1, r.errors.count)

				create formatter
				r.errors [1].multi_line_message (formatter)
				assert ("has_to_fail has failed", formatter.buffer.has_substring ("has_to_fail"))
			end
		end
end
