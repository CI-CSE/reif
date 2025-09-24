note
	description: "Tests for MML_BAG"
	testing: "autoproof", "type/manual", "execution/isolated"

class
	MML_BAG_TESTS

inherit
	AP_TEST_EXAMPLES

feature

	absence_of_type_errors
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
					demo (lhs:MML_BAG [INTEGER]; other: MML_BAG [INTEGER]): MML_BAG [INTEGER]
						do
							Result := lhs.difference (other)
						ensure
							Result = lhs.difference (other)
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("demo", "DEMO")

			verify

			assert_feature_verified ("demo", << "qualified", "unqualified" >>)
		end
end
