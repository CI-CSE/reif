note
	description: "Tests for E2B_VERIFICATION_ERROR"
	testing: "autoproof", "type/manual", "execution/isolated"

class
	E2B_VERIFICATION_ERROR_TESTS

inherit
	AP_TEST_EXAMPLES

feature -- multi_line_message

	multi_line_message_has_counterexample
		local
			formatter: STRING_TEXT_FORMATTER
			nums: ARRAY [STRING]
			pattern: STRING
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

					demo (a, b, c: DEMO; det: detachable DEMO)
						note
							explicit: contracts, wrapping
						do
							check c1: a /= Current end
							check c2: b /= c end
							check c3: det /= Void end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("demo", "DEMO")

			verify

			check attached {E2B_FAILED_VERIFICATION} verification_result as r then
				assert_equal ("3 errors", 3, r.errors.count)

				create formatter
				r.errors [1].multi_line_message (formatter)
				assert ("First error is c1", formatter.buffer.has_substring ("c1"))
				assert ("First error has a = Current text",
					formatter.buffer.has_substring ("a = Current"))

				create formatter
				r.errors [2].multi_line_message (formatter)
				assert ("Second error is c2", formatter.buffer.has_substring ("c2"))
				nums := << "", "" >>
				across << "b", "c" >> as var loop
					pattern := var + " = $"
					across
						formatter.buffer.substring (
							formatter.buffer.substring_index (pattern, 1) + pattern.count,
							formatter.buffer.count) as char
					until
						not char.is_digit
					loop
						nums [@ var.cursor_index].extend (char.to_character_8)
					end
				end
				assert ("Has number for b", not nums [1].is_empty)
				assert ("Has number for c", not nums [2].is_empty)
				assert_strings_equal ("Second error has b and c with same number",
					nums [1], nums [2])

				create formatter
				r.errors [3].multi_line_message (formatter)
				assert ("Third error is c3", formatter.buffer.has_substring ("c3"))
				assert ("Third error has det = Void",
					formatter.buffer.has_substring ("det = Void"))
			end
		end

	test_multiple_states
		local
			formatter: STRING_TEXT_FORMATTER
			part: STRING
		do
			print_file ("demo.e", "[
				class DEMO
				create make
				feature
					make
						do
						end

					test
						local
							a, b: ANY
						do
							create a
							b := a
							create a
							check False end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Result is failure", attached {E2B_FAILED_VERIFICATION} verification_result)
			check attached {E2B_FAILED_VERIFICATION} verification_result as r then
				assert_equal ("Has one error", 1, r.errors.count)
				create formatter
				r.errors [1].multi_line_message (formatter)
				assert ("Has initial state", formatter.buffer.has_substring ("DEMO.test =>"))
				assert ("Has state after 12",
					formatter.buffer.has_substring ("DEMO.test:12"))
				assert ("Has state after 13",
					formatter.buffer.has_substring ("DEMO.test:13"))

				assert ("Does not have temp_ variables",
					not formatter.buffer.has_substring ("temp_"))

				-- State DEMO.test
				part := formatter.buffer.substring (
					formatter.buffer.substring_index ("DEMO.test =>", 1),
					formatter.buffer.substring_index ("DEMO.test:12", 1)
				)
				assert ("Local a is Void", part.has_substring ("a = Void"))
				assert ("Local b is Void", part.has_substring ("b = Void"))
			end
		end

	test_mml_sequence
		local
			r: E2B_FAILED_VERIFICATION
			formatter: STRING_TEXT_FORMATTER
		do
			print_file ("demo.e", "[
				class DEMO
				create make
				feature
					make
						do
						end

					test
						local
							seq: MML_SEQUENCE [INTEGER]
						do
							create seq
							create seq.singleton (1)
							create seq.constant (10, 2)
							check False end
						end

					test_arg (a: MML_SEQUENCE [INTEGER])
						require
							a.count = 2
						local
							x: MML_SEQUENCE [INTEGER]
						do
							x := a.extended (1)
							check False end
						end

					test_items (b: MML_SEQUENCE [INTEGER])
						require
							b.count = 1
							b [1] = 10
						do
							check b [1] = 20 end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")
			command.add_feature ("test_arg", "DEMO")
			command.add_feature ("test_items", "DEMO")

			verify

			r := failure_of_feature ("test")
			assert ("Has failure for test", r /= Void)
			create formatter
			r.errors [1].multi_line_message (formatter)
			assert ("Has is constant", formatter.buffer.has_substring ("Constant(10, 2)"))
			assert ("Has is singleton", formatter.buffer.has_substring ("Singleton(1)"))
			assert ("Has length", formatter.buffer.has_substring ("Length = 0"))

			r := failure_of_feature ("test_arg")
			assert ("Has failure for test_arg", r /= Void)
			create formatter
			r.errors [1].multi_line_message (formatter)
			assert ("Has a length", formatter.buffer.has_substring ("Length = 2"))

			r := failure_of_feature ("test_items")
			assert ("Has failure for test_items", r /= Void)
			create formatter
			r.errors [1].multi_line_message (formatter)
			assert ("Has item", formatter.buffer.has_substring ("[1] = 10"))
		end

	test_mml_set
		local
			r: E2B_FAILED_VERIFICATION
			formatter: STRING_TEXT_FORMATTER
		do
			print_file ("demo.e", "[
			class DEMO
			create make
			feature
				make
					do
					end

				test_empty
					local
						set: MML_SET [INTEGER]
					do
						create set
						check False end
					end
			end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test_empty", "DEMO")

			verify

			r := failure_of_feature ("test_empty")
			create formatter
			r.errors [1].multi_line_message (formatter)
			assert ("Has set empty",
				formatter.buffer.has_substring ("set = <intType>Set#Empty()"))
			assert ("Has subjects empty",
				formatter.buffer.has_substring ("subjects = <refType>Set#Empty()"))
		end

	field_names_example
		local
			r: E2B_FAILED_VERIFICATION
			formatter: STRING_TEXT_FORMATTER
		do
			print_file ("parent.e", "[
				class PARENT
				feature
					in_parent: INTEGER
				end
			]")
			print_file ("demo.e", "[
				class DEMO
				inherit PARENT
					rename
						in_parent as renamed_in_demo
					end

				create make
				feature
					make
					do
					end

					the_field: INTEGER

					test
						require
							the_field = 1
							renamed_in_demo = 9
						do
							check the_field = 2 end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			r := failure_of_feature ("test")
			create formatter
			r.errors [1].multi_line_message (formatter)

			assert ("Has the_field value",
				formatter.buffer.has_substring ("the_field = 1"))
		end

	failure_of_feature (name: STRING): detachable E2B_FAILED_VERIFICATION
		do
			across verification_results as r until Result /= Void loop
				if attached {E2B_FAILED_VERIFICATION} r as e
					and then e.context_feature.feature_name ~ name then
					Result := e
				end
			end
		end
end
