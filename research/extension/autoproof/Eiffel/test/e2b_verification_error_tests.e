note
	description: "Tests for E2B_VERIFICATION_ERROR"
	testing: "type/manual"

class
	E2B_VERIFICATION_ERROR_TESTS

inherit
	AP_TEST_EXAMPLES

feature -- multi_line_message

	multi_line_message_has_counterexample
		note
			testing: "autoproof"
			testing: "execution/isolated"
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
				assert ("Second error has b = c text",
					formatter.buffer.has_substring ("b = c")
						or formatter.buffer.has_substring ("c = b"))

				create formatter
				r.errors [3].multi_line_message (formatter)
				assert ("Third error is c3", formatter.buffer.has_substring ("c3"))
				assert ("Third error has det = Void",
					formatter.buffer.has_substring ("det = Void"))
			end
		end
end
