note
	description: "AutoProof tests about references"
	testing: "autoproof", "type/manual", "execution/isolated"

class
	B_REFERENCES_TESTS

inherit
	AP_TEST_EXAMPLES

feature

	test_non_void_call
		do
			print_file ("b_references.e", "[
				class B_REFERENCES
				create
					make
				feature
					make
						do
						end

					non_void_call (a: ANY)
						note
							explicit: contracts, wrapping
						do
							if a /= Void then
								a.do_nothing
							end
						if attached a as l_a then
							l_a.do_nothing
						end
					ensure
						modify ([])
					end

					non_void_contract (a, b, c: ANY)
						note
							explicit: contracts, wrapping
						require
							a /= Void
							attached b
							attached {B_REFERENCES} c
						do
							a.do_nothing
							b.do_nothing
							if attached {B_REFERENCES} c as l_c then
								l_c.non_void_call (Current)
							else
								check unreachable: False end
							end
						end
				end
			]")
			print_ecf ("B_REFERENCES")
			command.add_feature ("non_void_call", "B_REFERENCES")
			command.add_feature ("non_void_contract", "B_REFERENCES")

			verify

			assert_feature_verified ("non_void_call", << "qualified", "unqualified" >>)
			assert_feature_verified ("non_void_contract", << "qualified", "unqualified" >>)
		end
end

