note
	description: "Tests for MML_SEQUENCE"
	testing: "autoproof", "type/manual", "execution/isolated"

class
	MML_SEQUENCE_TEST

inherit
	AP_TEST_EXAMPLES

feature

	test_attached_generic
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

					test (att: MML_SEQUENCE [attached ANY])
						require
							att.count > 0
						do
							check att_non_void: att [1] /= Void end
							check att_void: att [1] = Void end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert_verification_failure_with_tag ("att_void")
			assert_no_verification_failure_with_tag ("att_non_void")
		end

	test_detachable_generic
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

					test (det: MML_SEQUENCE [detachable ANY])
						require
							det.count > 0
						do
							check det_non_void: det [1] /= Void end
							check det_void: det [1] = Void end
						end
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

				-- This can fail
			assert_verification_failure_with_tag ("det_void")

				-- This can fail too
			assert_verification_failure_with_tag ("det_non_void")
		end
end
