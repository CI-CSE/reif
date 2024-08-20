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
							check check_false: False end
						end
				end
				]"
			)
			print_ecf ("DEMO")
			command.add_feature ("make", "DEMO")

			verify

			assert_equal ("Results of 3 variants", 3, verification_results.count)

			assert_feature_unverified ("make", << "qualified", "unqualified", "creator" >>)
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
								check check_true: True end
							end
					end
				]"
			)
			print_ecf ("DEMO")
			command.add_feature ("make", "DEMO")

			verify

			assert_equal ("Results of 3 variants", 3, verification_results.count)

			assert_feature_verified ("make", << "qualified", "unqualified", "creator" >>)
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

			create command.make (agent ({AP_TEST_ES}.command_line_io).output_window)
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
			file.put_encoding_bom
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
			-- `base` library and precompile contain the option readonly="false"
			--   to correctly register the changes to the system between test runs.
		local
			root_string: STRING
			void_safety_string: STRING
			precomp_ecf: STRING
			lib_ecf: STRING
		do
			if attached root then
				root_string := "<root class=%"" + root + "%" feature=%"make%" />"
			else
				root_string := "<root all_classes=%"true%" />"
			end

			if is_void_safe then
				void_safety_string := ""
				precomp_ecf := "test_precomp-safe.ecf"
				lib_ecf := "base-safe.ecf"
			else
				void_safety_string := "<void_safety support=%"none%" />"
				precomp_ecf := "test_precomp.ecf"
				lib_ecf := "base.ecf"
			end

			print_file ("Ace.ecf", "[
						<?xml version="1.0" encoding="ISO-8859-1"?>
							<system xmlns="http://www.eiffel.com/developers/xml/configuration-1-22-0" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.eiffel.com/developers/xml/configuration-1-22-0 http://www.eiffel.com/developers/xml/configuration-1-22-0.xsd" name="autoproof-tests" uuid="B9FC6CC3-5F19-4CE1-9131-56A0455E9224">
								<target name="tests">
									]" + "%N" + root_string + "%N" + "[
								<setting name="console_application" value="true"/>
								<capability>
									]" + "%N" + void_safety_string + "%N" + "[
									<concurrency support="none"/>
								</capability>
								<precompile name="test_precomp" readonly="false"
									]" + " location=%"$AP\test\precomp\" + precomp_ecf + "%"" + "[
								/>
								<library name="base" readonly="false"
									]" + " location=%"$AP\library\base\" + lib_ecf + "%"" + "[
								/>

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

	e2b_result: E2B_RESULT
			-- AutoProof execution result. Available after `verify`.
		do
			assert_equal ("One e2b_result", 1, results.count)
			Result := results [1]
		end

	verification_results: LINKED_LIST [E2B_VERIFICATION_RESULT]
		-- Verification results of features and other verification targets
		do
			Result := e2b_result.verification_results
		end

	assert_verification_failure_with_tag (t: STRING)
		local
			found: BOOLEAN
			other: STRING
		do
			other := ""
			across verification_results as res until found loop
				if attached {E2B_FAILED_VERIFICATION} res as failed then
					across failed.errors as error until found loop
						if attached {E2B_DEFAULT_VERIFICATION_ERROR} error as def then
							if def.tag ~ t then
								found := True
							else
								if other.is_empty then
									other := other + def.tag
								else
									other := other + ", " + def.tag
								end
							end
						end
					end
				end
			end

			assert (
				"Expected verification error with tag " + t + " but found other tags [" + other + "]",
				found
			)
		end

	assert_no_verification_failure_with_tag (t: STRING)
		local
			found: BOOLEAN
			other: STRING
		do
			across verification_results as res until found loop
				if attached {E2B_FAILED_VERIFICATION} res as failed then
					across failed.errors as error until found loop
						if attached {E2B_DEFAULT_VERIFICATION_ERROR} error as def then
							if def.tag ~ t then
								found := True
							end
						end
					end
				end
			end

			assert (
				"Expected no verification failure with tag " + t,
				not found
			)
		end

	verification_result: E2B_VERIFICATION_RESULT
			-- If only one result is expected, get the result
		do
			assert_equal ("One E2B_VERIFICATION_RESULT", 1, verification_results.count)
			Result := verification_results.first
		end

	result_of_feature (feature_name, context: STRING): detachable E2B_VERIFICATION_RESULT
		do
			across
				verification_results as i
			until
				attached Result
			loop
				if
					i.context_feature.feature_name ~ feature_name
					and then i.verification_context.starts_with (context)
				then
					Result := i
				end
			end
		end

	assert_feature_verified_context (feature_name, context: STRING)
		do
			assert ("Feature " + feature_name + " (" + context + ") verified",
				attached {E2B_SUCCESSFUL_VERIFICATION} result_of_feature (
					feature_name, context))
		end

	assert_feature_verified (feature_name: STRING; contexts: ARRAY [STRING])
		do
			across contexts as c loop
				assert_feature_verified_context (feature_name, c)
			end
		end

	assert_feature_unverified_context (feature_name, context: STRING)
		do
			assert ("Feature " + feature_name + " (" + context + ") unverified",
				attached {E2B_FAILED_VERIFICATION} result_of_feature (
					feature_name, context))
		end

	assert_feature_unverified (feature_name: STRING; contexts: ARRAY [STRING])
		do
			across contexts as c loop
				assert_feature_unverified_context (feature_name, c)
			end
		end
end
