note
	description: "Tests for precursor"
	testing: "autoproof", "type/manual", "execution/isolated"
class
	PRECURSOR_TESTS
inherit
	AP_TEST_EXAMPLES
feature
	precursor_is_not_treated_as_recursive_call
		do
			print_file ("test_precursor_parent.e", "[
class
	TEST_PRECURSOR_PARENT
create
	make

feature

	make
		do
		end

	test_precursor
		note
			explicit: wrapping
		require
			is_wrapped
		do
		ensure
			is_wrapped
		end
end
			]")
			print_file ("test_precursor_child.e", "[
class
	TEST_PRECURSOR_CHILD
inherit
	TEST_PRECURSOR_PARENT
		redefine
			test_precursor
		end
create
	make

feature 

	test_precursor 
		note
			explicit: wrapping
		do
			Precursor
		end
end
			]")
			print_ecf ("TEST_PRECURSOR_CHILD")
			command.add_feature ("test_precursor", "TEST_PRECURSOR_CHILD")

			verify

			assert ("Verification succeeds", attached {E2B_SUCCESSFUL_VERIFICATION} verification_result)
		end
end
