note
	description: "Tests related to AutoProof translation with and without Void-safety"
	testing: "autoproof", "type/manual", "execution/isolated"

class
	AP_VOID_SAFETY_TEST

inherit
	AP_TEST_EXAMPLES

feature
	test_argument_safe
		do
			is_void_safe := True

			print_file ("demo.e", "[
				class DEMO
				create make
				feature make do end
					test (a: ANY)
						note
							explicit: contracts, wrapping
						do
							check a /= Void end
						ensure
							modify ([])
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Verification is success",
				attached {E2B_SUCCESSFUL_VERIFICATION} verification_result)
		end

	test_argument_unsafe
		do
			is_void_safe := False

			print_file ("demo.e", "[
				class DEMO
				create make
				feature make do end
					test (a: ANY)
						note
							explicit: contracts, wrapping
						do
							check a /= Void end
						ensure
							modify ([])
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Verification is failure",
				attached {E2B_FAILED_VERIFICATION} verification_result)
		end

	test_attribute_safe
		do
			is_void_safe := True

			print_file ("demo.e", "[
				class DEMO
				create make
				feature
					make
						do
							right := Current
						end

					right: DEMO

					test
						note
							explicit: contracts, wrapping
						do
							check right /= Void end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Verification is success",
				attached {E2B_SUCCESSFUL_VERIFICATION} verification_result)
		end

	test_attribute_unsafe
		do
			is_void_safe := False

			print_file ("demo.e", "[
				class DEMO
				create make
				feature
					make
						do
							right := Current
						end

					right: DEMO

					test
						note
							explicit: contracts, wrapping
						do
							check right /= Void end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Verification is failure",
				attached {E2B_FAILED_VERIFICATION} verification_result)
		end

	test_create_object_with_attached_fields
		do
			print_file ("linked_node.e", "[
			  class LINKED_NODE
					create
						make
					feature
						make
							do
								right := Current
							end

						right: LINKED_NODE
				end
			]")
			print_file ("demo.e", "[
				class DEMO
					create
						make
					feature
						make
							do
							end
						test
							local
								a: LINKED_NODE
							do
								create a.make
								check c1: False end
							end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert_verification_failure_with_tag ("c1")
		end
end
