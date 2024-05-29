note
	description: "AutoProof tests about the `across` loops"
	testing: "autoproof", "type/manual", "execution/isolated"

class
	A_ACROSS_TESTS

inherit
	AP_TEST_EXAMPLES

feature

	test_set_across
		do
			print_file ("a_across.e", "[
				class A_ACROSS
				create make
				feature
					make
						do
						end

					set_across
						local
							l_set1: MML_SET [INTEGER]
							l_set2: MML_SET [BOOLEAN]
						do
							l_set1 := << 1, 2, 3, 4 >>
							check across l_set1 as i all 0 < i and i < 5 end end
							check across l_set1 as i all
									across l_set1 as j all 2 <= i + j and i + j <= 8  end
							end end

							l_set2 := << True, True >>
							check across l_set2 as i all i end end
						end
				end
			]")
			print_ecf ("A_ACROSS")
			command.add_feature ("set_across", "A_ACROSS")

			verify

			assert ("Verification result success",
				attached {E2B_SUCCESSFUL_VERIFICATION} verification_result)
		end
end
