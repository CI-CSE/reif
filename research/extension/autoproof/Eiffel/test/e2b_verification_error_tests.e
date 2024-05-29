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
end
