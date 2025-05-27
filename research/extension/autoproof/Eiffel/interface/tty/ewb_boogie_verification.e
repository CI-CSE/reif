note
	description: "Command line command for Boogie verification"
	date: "$Date$"
	revision: "$Revision$"

class
	EWB_BOOGIE_VERIFICATION

inherit

	E_CMD

	SHARED_ERROR_HANDLER
		export {NONE} all end

	SHARED_EIFFEL_PROJECT

	COMPILER_EXPORTER

	INTERNAL_COMPILER_STRING_EXPORTER

	E2B_SHARED_CONTEXT

	SHARED_SERVER

	EPA_COMPILATION_UTILITY

create
	make_with_arguments

feature {NONE} -- Initialization

	make_with_arguments (
		a_arguments: LIST [READABLE_STRING_GENERAL];
		a_get_output_window: FUNCTION [OUTPUT_WINDOW])
			-- Initialize with `a_arguments'.
			--
			-- Each arguments can be:
			-- * `CLASS_NAME` - to verify whole class `CLASS_NAME`
			-- * `CLASS_NAME.f_name` - to verify feature `f_name` in `CLASS_NAME`
			-- * Path to class file - to verify class
			--
			-- `a_get_output_window`: AutoProof output sink. Will be called once
			--   at the beginning of the execution.
		require
			a_arguments_attached: a_arguments /= Void
		do
			get_output_window := a_get_output_window

			create user_options.make
			user_options.compare_objects
			create selection.make
			from
				a_arguments.start
			until
				a_arguments.after
			loop
				if a_arguments.item.starts_with ("-") then
					user_options.extend (a_arguments.item)
					a_arguments.forth
					if not a_arguments.after and a_arguments.item.is_integer then
						user_options.extend (a_arguments.item)
						a_arguments.forth
					end
				else
					selection.extend (a_arguments.item)
					a_arguments.forth
				end
			end
		end

	get_output_window: FUNCTION [OUTPUT_WINDOW]

	output_window: OUTPUT_WINDOW
		once
			Result := get_output_window.item
		end

feature -- Access

	autoproof: E2B_AUTOPROOF
			-- Autoproof.

	user_options: LINKED_LIST [READABLE_STRING_GENERAL]
			-- Option arguments to Boogie command line.

	proof2test: E2B_PROOF_TO_TEST
			-- Proof2Test instance
		once
			create Result.make
		end

	selection: LINKED_LIST [READABLE_STRING_GENERAL]
			-- Class paths, class names and feature selection arguments
			-- to Boogie command line.

	name: STRING
		do
			Result := "Boogie Verification"
		end

	help_message: STRING_GENERAL
		do
			Result := "Verify project using Boogie verifier"
		end

	abbreviation: CHARACTER
		do
			Result := 'b'
		end

feature -- Execution

	execute
			-- <Precursor>
		local
			html_writer: E2B_HTML_OUTPUT
			l_html: BOOLEAN
			l_measure: BOOLEAN
			l_start, l_duration: NATURAL_64
		do
			create autoproof.make
				-- Load options
			if user_options.has ("-branchtests") then
				options.set_full_coverage_test_generation_enabled (True)
			elseif user_options.has ("-mcdctests") then
				options.set_full_mcdc_test_generation_enabled (True)
			end

			if user_options.has ("-twostep") then
				options.set_two_step_verification_enabled (True)
			elseif has_option ("-notwostep") then
				options.set_two_step_verification_enabled (False)
			end
			if has_option ("-postpredicate") then
				options.set_postcondition_predicate_enabled (True)
			elseif has_option ("-nopostpredicate") then
				options.set_postcondition_predicate_enabled (False)
			end
			if has_option ("-overflow") then
				options.set_checking_overflow (True)
			elseif has_option ("-nooverflow") then
				options.set_checking_overflow (False)
			end
			if has_option ("-trigger") then
				options.set_generating_triggers (True)
			elseif has_option ("-notrigger") then
				options.set_generating_triggers (False)
			end
			if has_option ("-arithtrigger") then
				options.set_triggering_on_arithmetic (True)
			elseif has_option ("-noarithtrigger") then
				options.set_triggering_on_arithmetic (False)
			end
			if has_option ("-arithfresh") then
				options.set_arithmetic_extracted (True)
			elseif has_option ("-noarithfresh") then
				options.set_arithmetic_extracted (False)
			end
			if has_option ("-independent") then
				options.set_inv_check_independent (True)
			elseif has_option ("-noindependent") then
				options.set_inv_check_independent (False)
			end
			if has_option ("-nonvariant") then
				options.set_ignoring_nonvariant (False)
			elseif has_option ("-nononvariant") then
				options.set_ignoring_nonvariant (True)
			end
			if has_option ("-autounroll") then
				options.set_automatic_loop_unrolling_enabled (True)
			elseif has_option ("-noautounroll") then
				options.set_automatic_loop_unrolling_enabled (False)
			end
			if user_options.has ("-unrolldepth") then
				user_options.search ("-unrolldepth")
				user_options.forth
				options.set_loop_unrolling_depth (option_argument ("-unrolldepth", user_options.item.to_integer))
			end
			if has_option ("-autoinline") then
				options.set_automatic_inlining_enabled (True)
			elseif has_option ("-noautoinline") then
				options.set_automatic_inlining_enabled (False)
			end
			if user_options.has ("-inlinedepth") then
				user_options.search ("-inlinedepth")
				user_options.forth
				options.set_max_recursive_inlining_depth (option_argument ("-inlinedepth", user_options.item.to_integer)) -- options.max_recursive_inlining_depth))
			end
			if has_option ("-ownership") then
				options.set_ownership_enabled (True)
			elseif has_option ("-noownership") then
				options.set_ownership_enabled (False)
			end
			if has_option ("-scdefaults") then
				options.set_ownership_defaults_enabled (True)
			elseif has_option ("-noscdefaults") then
				options.set_ownership_defaults_enabled (False)
			end
			if has_option ("-timeout") then
				options.set_is_enforcing_timeout (True)
				options.set_timeout (option_argument ("-timeout", options.timeout))
			end
			if has_option ("-printtime") then
				options.set_print_time (True)
			elseif has_option ("-noprinttime") then
				options.set_print_time (False)
			end
			if has_option ("-bulk") then
				options.set_bulk_verification_enabled (True)
			elseif has_option ("-forked") then
				options.set_bulk_verification_enabled (False)
				options.set_max_parallel_boogies (option_argument ("-forked", options.max_parallel_boogies))
			end
			l_measure := has_option ("-measure")
			l_html := has_option ("-html")
				-- Load input
			if selection.is_empty then
				load_universe
			else
				load_selection
			end

			if l_html then
				create html_writer
				html_writer.print_header
				autoproof.add_notification (agent html_writer.print_verification_result (?))
			else
				autoproof.add_notification (agent print_result (?))
			end

			l_start := current_time_millis

			if options.is_bulk_verification_enabled then
				autoproof.verify
			else
				autoproof.verify_forked
			end
			l_duration := current_time_millis - l_start

			if l_html then
				html_writer.print_footer
			end

			if l_measure then
				if l_html then
					output_window.add ("<p>Total time: " + l_duration.out + "</p>")
				else
					output_window.add ("Total time: " + l_duration.out + "%N")
				end
			end
		end

	has_option (s: READABLE_STRING_GENERAL): BOOLEAN
		do
			Result := ∃ o: user_options ¦ o.same_string (s)
		end

	option_argument (a_option: STRING; a_default: INTEGER): INTEGER
		require
			has_option (a_option)
		local
			l_index: INTEGER
		do
			across
				1 |..| user_options.count as i
			until
				l_index > 0
			loop
				if user_options [i].same_string (a_option) then
					l_index := i
				end
			end

			if l_index > 0 and then user_options.i_th (l_index + 1).is_integer then
				Result := user_options.i_th (l_index + 1).to_integer
			else
				Result := a_default
			end
		end

feature {NONE} -- Printing console

	print_result (a_result: E2B_RESULT)
			-- Print results to output.
		do
			if options.is_full_coverage_test_generation_enabled then
				start_timer
				proof2test.generate_tests (options.init_states_of_counterexamples)
				options.init_states_of_counterexamples.wipe_out
				stop_timer
				output_window.add ("Test generation finished. The generated test cases are in the file: " + proof2test.test_file_name + "%N")
				if options.test_generation_count < 19 then
					autoproof.verify
					options.increase_test_generation_count
				end
			else
				across a_result.verification_results as i loop
					output_window.add ("======================================%N")

				if attached {E2B_SUCCESSFUL_VERIFICATION} i as l_success then
					print_successful_verification (l_success)

				elseif attached {E2B_FAILED_VERIFICATION} i as l_failure then
					print_failed_verification (l_failure)

					if has_option ("-fix") then
						options.failures_for_fix.extend (l_failure)
					end
						-- TODO Li: display the failure in the "Faults" tab
				elseif attached {E2B_AUTOPROOF_ERROR} i as l_error then
					print_error (l_error)
				else
					check False end
				end

				if has_option ("-fix") then
					output_window.add ("fixing start time: " + timer.system_clock.time_now.out + "%N")
					generate_counterexamples_for_fix
				elseif has_option ("-validate_fix") then
				print_potential_fix
				-- TODO Li: this is a hack to get the context class
				reverify_with_check_false_instrumented (a_result.verification_results.last.context_class)
				end
			end
		end
		end

	get_valid_fixes_from_result (a_result: E2B_RESULT)
			-- Print results to output.
		do
			across a_result.verification_results as i loop
				if attached {E2B_FAILED_VERIFICATION} i as l_failure then
					options.valid_fixes.extend (l_failure.context_feature.feature_name)
				end
			end

			if not options.valid_fixes.is_empty then
				print_valid_fixes (a_result.verification_results.last.context_class)
			else
				output_window.add ("No valid fixes found.%N")
			end

		end

	print_valid_fixes (a_class: E2B_CLASS_C)
		-- Print out the ids of valid fixes
		local
			l_feature: E2B_FEATURE_I
			l_match_list: LEAF_AS_LIST
		do
			l_match_list := Match_list_server.item (a_class.class_id)

			output_window.add (Msg_valid_proof_fix + "%N")

			across options.valid_fixes as l_name loop
				l_feature := a_class.feature_named (l_name)
				output_window.add (l_feature.body.text(l_match_list))
				output_window.add ("%N------------------------------------------------------------------------------------%N")
			end
			output_window.add ("%N")
			output_window.add ("fixing end time: " + timer.system_clock.time_now.out + "%N")
		end

	print_potential_fix
		-- Print out the ids of potential fixes
		local
			l_id: STRING
		do
			output_window.add (Msg_potential_proof_fix + " ")
			across options.potential_fixes_names as l_name loop
				l_id := l_name.split ('_').last
				if l_id.is_integer then
					output_window.add (l_name.split ('_').last + " ")
				end
			end
			output_window.add ("%N")
		end

	print_successful_verification (a_success: E2B_SUCCESSFUL_VERIFICATION)
			-- Print successful verification information.
		local
			time_string: STRING
		do
			print_feature_information_for_success (a_success)

			if options.is_print_time then
				time_string := " (" + time_format.formatted (a_success.time) + "s)"
			else
				time_string := ""
			end
			if a_success.original_errors = Void or else a_success.original_errors.is_empty then
				output_window.add ("Successfully verified" + time_string + ".%N")
			else
					-- Two-step verification result
				output_window.add ("Successfully verified after inlining" + time_string + ".%N")
				output_window.add ("Original errors:%N")
				across a_success.original_errors as i loop
					if @i.cursor_index = 1 then
						output_window.add_new_line
					else
						output_window.add ("--------------------------------------%N")
					end
					i.multi_line_message (output_window)
					output_window.add_new_line
				end
			end
		end

	print_failed_verification (a_failure: E2B_FAILED_VERIFICATION)
			-- Print failed verifcation information.
		local
			time_string: STRING
			out_str: STRING
		do
			print_feature_information (a_failure)
			if options.is_print_time then
				time_string := " (" + time_format.formatted (a_failure.time) + "s)"
			else
				time_string := ""
			end
			output_window.add ("Verification failed" + time_string + ".%N")
			across a_failure.errors as i loop
				if @i.cursor_index = 1 then
					output_window.add_new_line
				else
					output_window.add ("--------------------------------------%N")
				end

				if has_option ("-fix") then
					out_str := i.context_class.name.twin; out_str.append_character (Msg_seperator)
					out_str := out_str + i.context_feature.feature_name; out_str.append_character (Msg_seperator)
					out_str := out_str + failure_code (i).out; out_str.append_character (Msg_seperator)
					out_str := out_str + i.context_line_number.out; out_str.append_character (Msg_seperator)
					output_window.add (Msg_proof_failed + out_str)
					i.single_line_message (output_window)
					output_window.add_new_line

				else
					if i.context_line_number > 0 then
						output_window.add ("Line: " + i.context_line_number.out + ". ")
					end
					i.multi_line_message (output_window)
					output_window.add_new_line
				end
			end
		end

	print_error (a_error: E2B_AUTOPROOF_ERROR)
			-- Print failed verifcation information.
		do
			print_feature_information (a_error)
			output_window.add ("AutoProof error.%N")
			if a_error.context_line_number > 0 then
				output_window.add ("Line: " + a_error.context_line_number.out + ". ")
			end
			output_window.add (a_error.type + ": ")
			a_error.single_line_message (output_window)
			output_window.add_new_line
		end

	print_feature_information_for_success (a_proc: E2B_VERIFICATION_RESULT)
			-- Print feature information.
		do
			if attached a_proc.context_class then
				output_window.add_class (a_proc.context_class.original_class)
			end
			if attached a_proc.context_feature then
				output_window.add (".")
				output_window.add_feature (a_proc.context_feature.e_feature, a_proc.context_feature.feature_name_32)
				if has_option ("-validate_fix") then
					if a_proc.context_feature.feature_name.has_substring ("_id_") then
						options.potential_fixes_names.extend (a_proc.context_feature.feature_name) -- the feature information is missing?
					end
				end
			end
			if attached a_proc.verification_context then
				output_window.add (" (")
				output_window.add (a_proc.verification_context)
				output_window.add (")")
			end
			output_window.add_new_line
		end

	print_feature_information (a_proc: E2B_VERIFICATION_RESULT)
			-- Print feature information.
		do
			if attached a_proc.context_class then
				output_window.add_class (a_proc.context_class.original_class)
			end
			if attached a_proc.context_feature then
				output_window.add (".")
				output_window.add_feature (a_proc.context_feature.e_feature, a_proc.context_feature.feature_name_32)
			end
			if attached a_proc.verification_context then
				output_window.add (" (")
				output_window.add (a_proc.verification_context)
				output_window.add (")")
			end
			output_window.add_new_line
		end

feature {NONE} -- Implementation

	load_universe
			-- Load all classes from universe.
		local
			l_groups: LIST [CONF_GROUP]
		do
			from
				l_groups := eiffel_universe.groups
				l_groups.start
			until
				l_groups.after
			loop
					-- Only load top-level clusters, as they are loaded recursively afterwards
				if attached {CLUSTER_I} l_groups.item_for_iteration as l_cluster and then l_cluster.parent_cluster = Void then
					load_cluster (l_cluster)
				end
				l_groups.forth
			end
		end

	load_selection
			-- Load verification targets
		local
			l_item: READABLE_STRING_GENERAL
			l_parts: LIST [READABLE_STRING_GENERAL]
			l_classes: LIST [CLASS_I]
			file: RAW_FILE
		do
			from
				selection.start
			until
				selection.after
			loop
				l_item := selection.item

				-- Try to find class by path
				create file.make_with_path (create {PATH}.make_from_string (selection.item))
				if file.exists and then attached class_by_path (file.path) as c then
					load_class (c)
				elseif l_item.has ('.') then
						-- It's an individual feature
					l_parts := l_item.split ('.')
					l_classes := universe.classes_with_name (l_parts.i_th (1))
					if l_classes /= Void and then not l_classes.is_empty then
						load_feature (l_classes.first, l_parts.i_th (2))
					else
						print ({STRING_32} "Class " + selection.item + " not found (skipped).%N")
					end
				else
						-- It's a class
					l_classes := universe.classes_with_name (selection.item)
					if l_classes /= Void and then not l_classes.is_empty then
						load_class (l_classes.first)
					else
						print ({STRING_32} "Class " + selection.item + " not found (skipped).%N")
					end
				end
				selection.forth
			end
		end

	class_by_path (path: PATH): detachable CLASS_I
			-- Find class by it's path.
			-- Void if class was not found
		do
			across universe.all_classes as c until Result /= Void loop
				if c.file_name.absolute_path ~ path.absolute_path then
					Result := c
				end
			end
		end

	load_feature (a_class: CLASS_I; a_feature_name: READABLE_STRING_GENERAL)
			-- Load `a_feature' for verification.
		local
			l_feature: FEATURE_I
		do
			if a_class.is_compiled then
				l_feature := a_class.compiled_class.feature_named_32 (a_feature_name)
				if l_feature /= Void then
					autoproof.add_feature (create {E2B_FEATURE_I}.make (l_feature))
				else
					print ({STRING_32} "Feature " + a_class.name + "." + a_feature_name + " not found (skipped).%N")
				end
			else
				print ("Class " + a_class.name + " not compiled (skipped).%N")
			end
		end

	reverify_with_check_false_instrumented (a_class: E2B_CLASS_C)
			-- Load `a_feature' for verification.
		local
			l_feature: E2B_FEATURE_I
			l_match_list: LEAF_AS_LIST
			l_class_file_name, l_class_text, l_old_class_text: STRING
			l_class_file_path: PATH
			l_class_file: PLAIN_TEXT_FILE
		do
				l_match_list := Match_list_server.item (a_class.class_id)
				l_old_class_text := ""
				l_old_class_text.copy (a_class.ast.text (l_match_list))

				across options.potential_fixes_names as l_name loop
					l_feature := a_class.feature_named (l_name)
					if l_feature /= Void then
						l_feature.e_feature.ast.body.as_routine.replace_subtext ("do", "do%Ncheck False end", True, l_match_list)
					else
						print ("Feature " + a_class.name + "." + l_name + " not found (skipped).%N")
					end
				end

				l_class_text := a_class.ast.text (l_match_list)

				l_class_file_name := a_class.name
				l_class_file_path := system.eiffel_project.project_directory.path.extended (l_class_file_name + ".e")
				create l_class_file.make_with_path (l_class_file_path)
				l_class_file.open_write
				l_class_file.put_string (l_class_text)
				l_class_file.close

				compile_project (eiffel_project, True)
				l_match_list.remove_modifications

				autoproof.reset
				across options.potential_fixes_names as l_name loop
					l_feature := a_class.feature_named (l_name)
					if l_feature /= Void then
						autoproof.add_feature (l_feature)
					end
				end
				autoproof.add_notification (agent get_valid_fixes_from_result (?))
				autoproof.verify
		end

	load_class (a_class: CLASS_I)
			-- Load `a_class' for verification.
		do
			if a_class.is_compiled then
				check a_class.compiled_class /= void end
				autoproof.add_class (create {E2B_CLASS_C}.make (a_class.compiled_class))
			else
				print ("Class " + a_class.name + " not compiled (skipped).%N")
			end
		end

	load_cluster (a_cluster: CLUSTER_I)
			-- Load `a_cluster' for verification.
		require
			a_cluster_not_void: a_cluster /= Void
		local
			l_conf_class: CONF_CLASS
			l_class_i: CLASS_I
		do
			from
				a_cluster.classes.start
			until
				a_cluster.classes.after
			loop
				l_conf_class := a_cluster.classes.item_for_iteration
				l_class_i := eiffel_universe.class_named (l_conf_class.name, a_cluster)
				load_class (l_class_i)
				a_cluster.classes.forth
			end
			if a_cluster.sub_clusters /= Void then
				from
					a_cluster.sub_clusters.start
				until
					a_cluster.sub_clusters.after
				loop
					load_cluster (a_cluster.sub_clusters.item_for_iteration)
					a_cluster.sub_clusters.forth
				end
			end
		end

	generate_counterexamples_for_fix
			-- Generate a number of counterexamples for fixing
		do
			options.set_generate_fix_enabled (True)
			options.set_number_of_iteration_for_fixing (option_argument ("-fix", 20))
			autoproof.clear_notifications
			autoproof.verify
		end

	failure_code (a_error: E2B_VERIFICATION_ERROR): INTEGER
			-- Return the failure code based on the type of verification error
		do
			if attached {E2B_DEFAULT_VERIFICATION_ERROR} a_error as err then
				if err.boogie_error.is_postcondition_violation then
					Result := {EXCEP_CONST}.postcondition
				elseif err.boogie_error.is_precondition_violation then
					Result := {EXCEP_CONST}.precondition
				elseif err.message.starts_with ("Invariant") then
					Result := {EXCEP_CONST}.class_invariant
				elseif err.message.starts_with ("Loop invariant") then
					Result := {EXCEP_CONST}.loop_invariant
				elseif err.message.has_substring ("Variant") or err.message.has_substring ("Integer variant") then
					Result := {EXCEP_CONST}.loop_variant
				end
			end
		end

	time_format: FORMAT_DOUBLE
			-- Format for verfication times.
		once
			create Result.make (4, 2)
		end

	current_time_millis: NATURAL_64
		external
			"C inline use <time.h>, <sys/timeb.h>"
		alias
			"[
				struct timeb t;
				ftime(&t);
				return (unsigned long long int)time(NULL) * 1000 + t.millitm;
			]"
		end

feature

	Msg_ce_generated: STRING = "<[- CE generated ]>"

	Msg_proof_failed: STRING = "<[- Proof failed ]>"

	Msg_potential_proof_fix: STRING = "<[- Potential fix ]>"

	Msg_fix_ended: STRING = "<[- Fixing process finished ]>"

	Msg_valid_proof_fix: STRING = " ===================================  Valid Fix =================================="

	Msg_seperator: CHARACTER = '|'

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"

end
