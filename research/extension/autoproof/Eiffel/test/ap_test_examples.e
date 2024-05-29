note
	description: "End-to-end AutoProof tests"
	testing: "autoproof", "type/manual", "execution/isolated"
			-- fresh compiler instance is needed
			-- because `verify` runs full Eiffel compilation,
			-- which sets some `once` features in the compiler.

class
	AP_TEST_EXAMPLES

inherit
	AP_TEST
		redefine
			on_prepare
		end

feature -- Testing

	example_check_false
			-- Verifying `check False end` should give a failed verification.
		do
			print_file ("demo.e", "[
				class DEMO

				create
					make

				feature

					make
						do
						end

					test
						do
							check check_false: False end
						end
				end
				]"
			)
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Verification is failure", attached {E2B_FAILED_VERIFICATION} verification_result)
			assert_strings_equal ("Failure in DEMO class", "DEMO", verification_result.context_class.name)
			assert_strings_equal ("Failure in test feature", "test", verification_result.context_feature.feature_name_32)
		end

	example_check_true
			-- Verifying `check True end` should give successful verification.
		do
			print_file ("demo.e", "[
					class DEMO

					create
						make

					feature
						make
							do
							end

						test
							do
								check check_true: True end
							end
					end
				]"
			)
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			assert ("Verification is success", attached {E2B_SUCCESSFUL_VERIFICATION} verification_result)
			assert_strings_equal ("Success in DEMO class", "DEMO", verification_result.context_class.name)
			assert_strings_equal ("Success in test feature", "test", verification_result.context_feature.feature_name_32)
		end

feature {NONE} -- Initialization

	on_prepare
		local
			root_path: PATH
		do
			is_void_safe := True

			check attached environment.item ({EQA_TEST_SET}.testing_directory_key) as test_dir
				and then attached environment.item ({EQA_TEST_SET}.test_name_key) as test_name then
				create root_path.make_from_string (test_dir)
				root_path := root_path.extended ("ap_test_examples_executions").extended (test_name)
			end
			code_path := root_path.extended ("code")
			(create {DIRECTORY}.make_with_path (code_path)).recursive_create_dir

			create command.make
			create results.make
		end


	code_path: PATH
			-- Path to the "code" temporary directory of the current test

feature {NONE} -- Building test projects

	print_file (file_name: STRING; contents: READABLE_STRING_GENERAL)
			-- Add file named `file_name` with contents `contents`
			-- under `code_path`.
		local
			file: PLAIN_TEXT_FILE
		do
			create file.make_with_path (code_path.extended (file_name))
			file.open_write
			file.put_string_general (contents)
			file.close
		end

	is_void_safe: BOOLEAN
			-- Compile and verify as a Void-safe project?
			-- Used by `print_ecf`.

	print_ecf (root: detachable STRING)
			-- Add the project ECF file with the root class `root`.
			--
			-- If `root` is not Void, it should be the root class name.
			-- If `root` is Void, root is all_classes (like in a library).
			--
			-- Other options which are attributes in `Current`:
			-- `is_void_safe`
			--
			-- <library ../> contains the option readonly="false" to correctly register the changes to the system between test runs.
		local
			root_string: STRING
			void_safety_string: STRING
		do
			if attached root then
				root_string := "<root class=%"" + root + "%" feature=%"make%" />"
			else
				root_string := "<root all_classes=%"true%" />"
			end

			void_safety_string := if is_void_safe then
				"<void_safety support=%"all%" />"
			else
				"<void_safety support=%"none%" />"
			end

			print_file ("Ace.ecf", "[
						<?xml version="1.0" encoding="ISO-8859-1"?>
							<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-22-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-22-0 http://www.eiffel.com/developers/xml/configuration-1-22-0.xsd" name="autoproof-tests" uuid="B9FC6CC3-5F19-4CE1-9131-56A0455E9224">
								<target name="tests">
									]" + "%N" + root_string + "%N" + "[
								<option warning="warning" full_class_checking="false" is_obsolete_routine_type="true" syntax="transitional">
									<assertions precondition="true" postcondition="true" check="true" invariant="true" loop="true" supplier_precondition="true"/>
								</option>
								<setting name="console_application" value="true"/>
								<capability>
									]" + "%N" + void_safety_string + "%N" + "[
								</capability>
						    	<library name="base" location="$AP\library\base\base-scoop-safe.ecf" readonly="false" />
								<cluster name="autoproof_tests" location=".\">
									<file_rule>
										<exclude>/.svn$</exclude>
										<exclude>/CVS$</exclude>
										<exclude>/EIFGENs$</exclude>
									</file_rule>
								</cluster>
							</target>
						</system>
					]"
				)
		end

	verify
			-- Run verification, fill `results`
		local
			es: AP_TEST_ES
		do
			create es.make (<<
				"-batch",
				"-project_path", code_path.out,
				"-config", code_path.extended ("Ace.ecf").out
			>>)
			es.execute (es.preference_access)

			results.wipe_out
			command.autoproof.add_notification (agent results.extend (?))
			command.main_execute
		end

	command: E_AUTOPROOF
			-- Configurable autoproof verification

	results: LINKED_LIST [E2B_RESULT]
			-- Results of executing `command`

	verification_result: E2B_VERIFICATION_RESULT
		do
			assert_equal ("One E2B_VERIFICATION_RESULT", 1, verification_results.count)
			Result := verification_results [1]
		end

	verification_results: LINKED_LIST [E2B_VERIFICATION_RESULT]
		do
			assert_equal ("One E2B result", 1, results.count)
			Result := results [1].verification_results
		end

end
