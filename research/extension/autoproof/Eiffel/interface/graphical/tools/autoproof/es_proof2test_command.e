note
	description: "[
			Command to launch AutoProof.
			
			Can be added to toolbars and menus.
			Can be executed using stones.
		]"

class
	ES_PROOF2TEST_COMMAND

inherit

	EB_TOOLBARABLE_AND_MENUABLE_COMMAND
		redefine
			tooltext,
			new_sd_toolbar_item,
			new_mini_sd_toolbar_item,
			initialize_sd_toolbar_item
		end

	SHARED_EIFFEL_PROJECT

	SHARED_WORKBENCH

	SHARED_ERROR_HANDLER

	COMPILER_EXPORTER

	EB_SHARED_WINDOW_MANAGER

	E2B_SHARED_CONTEXT

create
	make

feature {NONE} -- Initialization

	make (an_error: E2B_VERIFICATION_ERROR; a_failure: E2B_FAILED_VERIFICATION; a_row: EV_GRID_ROW)
			-- Creation method.
		do
			enable_sensitive
				-- set_up_menu_items
			error := an_error
			failure := a_failure
			target_row := a_row
			print("Proof2Test command for " + error.context_feature.feature_name_32.to_string_8 + "%N")
		end

feature -- Execution

	execute
			-- Execute menu command.
		do
			-- execute_generate_test_item
		end

	execute_with_stone (a_stone: STONE)
			-- Execute with `a_stone'.
		do
			execute_with_stone_content (a_stone, Void)
		end

	execute_with_stone_content (a_stone: STONE; a_content: SD_CONTENT)
			-- Execute with `a_stone'.
		local
			l_save_confirm: ES_DISCARDABLE_COMPILE_SAVE_FILES_PROMPT
			l_classes: DS_ARRAYED_LIST [CLASS_I]
		do
			if not eiffel_project.is_compiling then
				if window_manager.has_modified_windows then
					create l_classes.make_default
					window_manager.all_modified_classes.do_all (agent l_classes.force_last)
					create l_save_confirm.make (l_classes)
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.yes_button, agent save_compile_and_verify (a_stone))
					l_save_confirm.set_button_action (l_save_confirm.dialog_buttons.no_button, agent compile_and_verify (a_stone))
					l_save_confirm.show_on_active_window
				else
					compile_and_verify (a_stone)
				end
			end
		end

	stop_verification
			-- Stop running verification.
		local
			l_autoproof: E2B_AUTOPROOF
			l_error: E2B_AUTOPROOF_ERROR
		do
			-- print ("ES_AUTOPROOF_COMMAND.stop_verification%N")
			l_autoproof := (create {ES_AUTOPROOF_BENCH_HELPER}).autoproof
			if autoproof.is_running then
				autoproof.cancel
					-- enable_tool_button
				window_manager.display_message ("Proof2Test canceled")

				event_list.prune_event_items (event_context_cookie)

				create l_error
				l_error.set_type ("canceled")
				l_error.set_message ("Execution canceled by user.")
				event_list.put_event_item (event_context_cookie, create {E2B_VERIFICATION_EVENT}.make (l_error))
			end
		end

feature {NONE} -- Basic operations

	save_compile_and_verify (a_stone: STONE)
			-- Save modified windows, compile project and start verification.
		do
			window_manager.save_all_before_compiling
			compile_and_verify (a_stone)
		end

	compile_and_verify (a_stone: STONE)
			-- Compile project and start verification.
		local
			l_helper: ES_PROOF2TEST_BENCH_HELPER
			l_dialog: ES_INFORMATION_PROMPT
		do
			if workbench.is_changed then
				eiffel_project.quick_melt (True, True, True)
			end
			if eiffel_project.successful then
				create l_helper
				if l_helper.autoproof.is_running then
					create l_dialog.make_standard ("AutoProof is already running.%NPlease wait until previous verification is finished.")
					l_dialog.show_on_active_window
				else
					verify (a_stone)
				end
			end
		end

	verify_for_new_counterexample
			-- Perform the reverification for minimization.
		local
			l_context: E2B_SHARED_CONTEXT
		do
			autoproof := (create {ES_PROOF2TEST_BENCH_HELPER}).autoproof
			autoproof.reset

				-- disable_tool_button
			create l_context
			l_context.status_notifier_agent_cell.put (agent window_manager.display_message)
			window_manager.display_message ("Generation of new counterexample running")

			autoproof.add_notification (agent process_new_counterexample_result)
			options.set_target_feature (failure.context_feature)
			options.set_target_class (failure.context_class)
			if failure.errors.has (error) then
				options.set_target_error_index (failure.errors.index_of (error, 1))
			end

			autoproof.verify
		end

       verify_for_possible_fix
			-- Perform reverification for generating possible fixes.
		local
			l_context: E2B_SHARED_CONTEXT
		do
			autoproof := (create {ES_PROOF2TEST_BENCH_HELPER}).autoproof
			autoproof.reset

				-- disable_tool_button
			create l_context
			l_context.status_notifier_agent_cell.put (agent window_manager.display_message)
			window_manager.display_message ("Generation of possible fix running")

			autoproof.add_notification (agent process_fix_result)
			options.set_target_feature (failure.context_feature)
			options.set_target_class (failure.context_class)
			if failure.errors.has (error) then
				options.set_target_error_index (failure.errors.index_of (error, 1))
			end

			autoproof.verify
		end

	verify_for_minimization
			-- Perform the reverification for minimization.
		local
			l_context: E2B_SHARED_CONTEXT
		do
			autoproof := (create {ES_PROOF2TEST_BENCH_HELPER}).autoproof
			autoproof.reset

				-- disable_tool_button
			create l_context
			l_context.status_notifier_agent_cell.put (agent window_manager.display_message)
			window_manager.display_message ("Minimization running")

			autoproof.add_notification (agent process_minimization_result)
			options.set_target_feature (failure.context_feature)
			options.set_target_class (failure.context_class)
			if failure.errors.has (error) then
				options.set_target_error_index (failure.errors.index_of (error, 1))
			end

			autoproof.verify
		end

	verify (a_stone: STONE)
			-- Verify `a_stone'.
		local
			l_context: E2B_SHARED_CONTEXT
		do
			autoproof := (create {ES_PROOF2TEST_BENCH_HELPER}).autoproof
			autoproof.reset

			if attached {FEATURE_STONE} a_stone as s then
				autoproof.add_feature (s.e_feature.associated_feature_i)
			elseif attached {CLASSI_STONE} a_stone as s then
				load_class (s.class_i)
			elseif attached {CLUSTER_STONE} a_stone as s then
				if s.is_cluster then
					load_cluster (s.cluster_i)
				else
					load_group (s.group)
				end
			elseif attached {DATA_STONE} a_stone as s then
				if attached {LIST [CONF_GROUP]} s.data as g then
					from
						g.start
					until
						g.after
					loop
						if attached {CLUSTER_I} g.item_for_iteration as c then
							load_cluster (c)
						end
						g.forth
					end
				end
			else
				across eiffel_universe.groups as g loop
						-- Only load top-level clusters, as they are loaded recursively afterwards.
					if
						attached {CLUSTER_I} g as c and then
						c.parent_cluster = Void
					then
						load_cluster (c)
					end
				end
			end
				-- disable_tool_button
			create l_context
			l_context.status_notifier_agent_cell.put (agent window_manager.display_message)
			window_manager.display_message ("AutoProof running")

			autoproof.add_notification (agent process_minimization_result)
			autoproof.verify

		end

	process_minimization_result (a_result: E2B_RESULT)
			-- Process verification result.
		local
			index: INTEGER
			l_row: EV_GRID_ROW
			l_lab: EV_GRID_PIXMAPS_ON_RIGHT_LABEL_ITEM
		do
				-- event_list.prune_event_items (event_context_cookie)
				-- across a_result.verification_results as i loop
				-- 	event_list.put_event_item (event_context_cookie, create {E2B_VERIFICATION_EVENT}.make (i))
				-- end
				-- show_proof_tool
				-- enable_tool_button
				-- add_init_states
				-- target_row.set_item (5, create {EV_GRID_LABEL_ITEM}.make_with_text (options.new_ce_message))
			-- a_result.autoproof_errors

			index := target_row.subrow_count + 1
			target_row.insert_subrow (target_row.subrow_count + 1)
			l_row := target_row.subrow (index)
			l_row.set_item (2, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (3, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (4, create {EV_GRID_LABEL_ITEM})

			create l_lab
			l_lab.set_text ("Minimal: " + options.new_ce_message)
			l_lab.set_pixmaps_on_right_count (1)
			l_lab.put_pixmap_on_right ({EB_SHARED_PIXMAPS}.icon_pixmaps.preference_list_icon, 1)
			l_lab.pointer_button_press_actions.extend
			(agent (i_x, i_y, i_but: INTEGER; i_x_tilt, i_y_tilt, i_pressure: DOUBLE; i_screen_x, i_screen_y: INTEGER) do on_minimal_counterexample_select_action (options.current_ce_init_state) end)

			l_row.set_item (5, l_lab)
			l_row.set_background_color (create {EV_COLOR}.make_with_rgb (0.8, 0.9, 1.0))
			target_row.expand
				-- TODO: display minimized counterexamples
				-- obtain the index of the error?
				-- failure.errors

				-- proof2test.generate_tests (options.init_states_of_counterexamples)
				-- eiffel_project.discover_melt
			window_manager.display_message ("Minimization finished.")

		end

	process_new_counterexample_result (a_result: E2B_RESULT)
			-- Process verification result.
		local
			index: INTEGER
			l_row: EV_GRID_ROW
			l_lab: EV_GRID_PIXMAPS_ON_RIGHT_LABEL_ITEM
			-- pixmaps: ES_ICONS
		do
				-- target_row.set_item (5, create {EV_GRID_LABEL_ITEM}.make_with_text (options.new_ce_message))
			index := target_row.parent_row.subrow_count + 1
			target_row.parent_row.insert_subrow (index)

			l_row := target_row.parent_row.subrow (index)

			l_row.set_item (2, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (3, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (4, create {EV_GRID_LABEL_ITEM})

			create l_lab
			l_lab.set_text ("Counterexample: " + options.new_ce_message)
			l_lab.set_pixmaps_on_right_count (1)
			l_lab.put_pixmap_on_right ({EB_SHARED_PIXMAPS}.icon_pixmaps.preference_list_icon, 1)
				-- l_lab.pixmaps_on_right.item (1).pointer_button_press_actions.extend (agent (i_x, i_y, i_but: INTEGER; i_x_tilt, i_y_tilt, i_pressure: DOUBLE; i_screen_x, i_screen_y: INTEGER) do on_counterexample_select_action end)
			l_row.set_item (5, l_lab)

			target_row := l_row

			-- l_lab.pointer_button_press_actions.extend (agent (i_x, i_y, i_but: INTEGER; i_x_tilt, i_y_tilt, i_pressure: DOUBLE; i_screen_x, i_screen_y: INTEGER) do on_counterexample_select_action (options.current_ce_init_state) end)

			l_row.set_background_color (create {EV_COLOR}.make_with_rgb (0.8, 0.9, 1.0))

				-- proof2test.generate_tests (options.init_states_of_counterexamples)
				-- eiffel_project.discover_melt
			window_manager.display_message ("Generation of new counterexample finished.")

		end

     process_fix_result (a_result: E2B_RESULT)
     			-- Process fix result.
		local
			index: INTEGER
			l_row: EV_GRID_ROW
			l_lab: EV_GRID_PIXMAPS_ON_RIGHT_LABEL_ITEM
			-- pixmaps: ES_ICONS
		do
			-- print ("new ce: " + options.fix_message + "%N")
				-- target_row.set_item (5, create {EV_GRID_LABEL_ITEM}.make_with_text (options.new_ce_message))
			index := target_row.parent_row.subrow_count + 1
			target_row.parent_row.insert_subrow (index)

			l_row := target_row.parent_row.subrow (index)

			l_row.set_item (2, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (3, create {EV_GRID_LABEL_ITEM})
			l_row.set_item (4, create {EV_GRID_LABEL_ITEM})

			create l_lab
			l_lab.set_text ("Fix: " + options.fix_message)
			l_lab.set_pixmaps_on_right_count (1)
			l_lab.put_pixmap_on_right ({EB_SHARED_PIXMAPS}.icon_pixmaps.preference_list_icon, 1)
				-- l_lab.pixmaps_on_right.item (1).pointer_button_press_actions.extend (agent (i_x, i_y, i_but: INTEGER; i_x_tilt, i_y_tilt, i_pressure: DOUBLE; i_screen_x, i_screen_y: INTEGER) do on_counterexample_select_action end)
			l_row.set_item (5, l_lab)

			target_row := l_row

			-- l_lab.pointer_button_press_actions.extend (agent (i_x, i_y, i_but: INTEGER; i_x_tilt, i_y_tilt, i_pressure: DOUBLE; i_screen_x, i_screen_y: INTEGER) do on_counterexample_select_action end)
			-- TODO: show the generated fixes

			l_row.set_background_color (create {EV_COLOR}.make_with_rgb (0.8, 0.9, 1.0))

				-- proof2test.generate_tests (options.init_states_of_counterexamples)
				-- eiffel_project.discover_melt
			window_manager.display_message ("Generation of possible fix finished.")

		end

feature {ES_AUTOPROOF_TOOL_PANEL}

	on_minimal_counterexample_select_action (a_ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE)-- (a_row: EV_GRID_ROW; an_error: E2B_VERIFICATION_ERROR; a_failure: E2B_FAILED_VERIFICATION)
			-- Display a menu on selecting a counterexample message
		local
			counterexample_menu: EV_MENU
			generate_minimal: EV_CHECK_MENU_ITEM
			generate_other: EV_CHECK_MENU_ITEM
			generate_test: EV_CHECK_MENU_ITEM
		do
			create counterexample_menu.make_with_text ("Counterexample")
			create generate_test.make_with_text_and_action ("Test", agent execute_generate_test_item (a_ce_init_state))
			counterexample_menu.extend (generate_test)
			counterexample_menu.show
		end

	on_counterexample_select_action (a_ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE)
			-- Display a menu on selecting a counterexample message
		local
			counterexample_menu: EV_MENU
			generate_minimal, generate_other, generate_test, generate_fix: EV_CHECK_MENU_ITEM
			-- l_ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE
		do
			print("on_counterexample_select_action%N")
			-- create l_ce_init_state.make (a_target_feature: FEATURE_I, a_target_class: CLASS_C, a_ce: E2B_BOOGIE_COUNTEREXAMPLE) a_ce_init_state
			create counterexample_menu.make_with_text ("Counterexample")

			create generate_minimal.make_with_text_and_action ("Minimal", agent execute_generate_minimal_counterexample_item)
			create generate_other.make_with_text_and_action ("New", agent execute_generate_new_counterexample_item)
			print("hhh: " + error.context_feature.feature_name_32.to_string_8 + " " + error.context_class.name+ "%N")
			create generate_test.make_with_text_and_action ("Test", agent execute_generate_test_item (error.ce_init_state))
			create generate_fix.make_with_text_and_action ("Fix", agent execute_generate_fix_item)

			counterexample_menu.extend (generate_other)
			counterexample_menu.extend (generate_minimal)
			counterexample_menu.extend (generate_test)
			counterexample_menu.extend (generate_fix)
			counterexample_menu.show
		end

	add_init_states
			-- Insert initial states generated from counterexamples
		local
			l_model_parser: E2B_BOOGIE_COUNTEREXAMPLE_PARSER
			l_init_state: E2B_INITIAL_STATE_OF_ROUTINE
			i: INTEGER
		do
			options.init_states_of_counterexamples.wipe_out

			i := 1
			across options.model_files as m loop
				create l_model_parser.make (system.eiffel_project.project_directory.target_path.extended ("Proofs").extended (m + ".model").out)
				across l_model_parser.counterexamples [m] as ce loop
					create l_init_state.make (options.features_to_optimize [i].target_feature, options.features_to_optimize [i].target_class, ce)
					options.init_states_of_counterexamples.extend (l_init_state)
				end
				i := i + 1
			end
		end

	event_context_cookie: UUID
			-- Context cookie for AutoProof events.
		once
			Result := {UUID_GENERATOR}.generate_uuid
		end

	proof_tool: detachable ES_AUTOPROOF_TOOL
			-- Proof tool (if applicable).
		local
			l_window: EB_DEVELOPMENT_WINDOW
		do
			l_window := window_manager.last_focused_development_window
			if not l_window.is_recycled and then l_window.is_visible and then l_window = window_manager.last_focused_development_window then
				Result := {ES_AUTOPROOF_TOOL} / l_window.shell_tools.tool ({ES_AUTOPROOF_TOOL})
			end
		end

	show_proof_tool
			-- Shows the proof tool
		do
			if attached proof_tool as t and then not t.is_recycled then
				t.show (True)
			end
		end

		-- disable_tool_button
		-- Disable proof button on tool.
		--	do
		--		if attached proof_tool as t and then t.is_tool_instantiated then
		--			t.panel.proof2test_button.disable_sensitive
		--			t.panel.proof2test_stop_button.enable_sensitive
		--		end
		--	end

		-- enable_tool_button
		-- Enable proof button on tool.
		--	do
		--		if attached proof_tool as t and then t.is_tool_instantiated then
		--			t.panel.proof2test_button.enable_sensitive
		--			t.panel.proof2test_stop_button.disable_sensitive
		--		end
		--	end

	load_class (a_class: CLASS_I)
			-- Load `a_class' for verification.
		local
			l_class_c: CLASS_C
		do
			if a_class.is_compiled then
				l_class_c := a_class.compiled_class
				check l_class_c /= Void end
				autoproof.add_class (l_class_c)
			end
		end

	load_cluster (g: CLUSTER_I)
			-- Load `g` for verification.
		require
			attached g
		do
			autoproof.add_group (g)
		end

	load_group (g: CONF_GROUP)
			-- Load `g` for verification.
		require
			attached g
		do
			autoproof.add_group (g)
		end

feature -- Items

	new_sd_toolbar_item (display_text: BOOLEAN): EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON
			-- <Precursor>
		do
			create Result.make (Current)
			initialize_sd_toolbar_item (Result, display_text)
			Result.select_actions.extend (agent execute_last_action)

			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	new_mini_sd_toolbar_item: EB_SD_COMMAND_TOOL_BAR_BUTTON
			-- <Precursor>
		do
			Result := Precursor {EB_TOOLBARABLE_AND_MENUABLE_COMMAND}
			Result.drop_actions.extend (agent execute_with_stone)
			Result.drop_actions.set_veto_pebble_function (agent droppable)
		end

	initialize_sd_toolbar_item (a_item: EB_SD_COMMAND_TOOL_BAR_DUAL_POPUP_BUTTON; display_text: BOOLEAN)
			-- <Precursor>
		do
			Precursor (a_item, display_text)
				-- a_item.set_menu_function (agent drop_down_menu)
		end

feature -- Status report

	droppable (a_pebble: ANY): BOOLEAN
			-- Can user drop `a_pebble' on `Current'?
		do
			Result :=
				(attached {FEATURE_STONE} a_pebble) or else
				(attached {CLASSI_STONE} a_pebble as s and then s.class_i.is_compiled) or else
				(attached {CLUSTER_STONE} a_pebble) or else
				(attached {DATA_STONE} a_pebble as s and then attached {LIST [CONF_GROUP]} s.data)
		end

feature {ES_AUTOPROOF_TOOL_PANEL} -- Implementation

	autoproof: E2B_AUTOPROOF
			-- AutoProof instance.

	proof2test: E2B_PROOF_TO_TEST
			-- Proof2Test instance
		once
			create Result.make
		end

	pixmap: EV_PIXMAP
			-- Pixmap representing the command.
		do
			Result := pixmaps.icon_pixmaps.verifier_to_testing_tool_icon
		end

	pixel_buffer: EV_PIXEL_BUFFER
			-- Pixel buffer representing the command.
		do
			Result := pixmaps.icon_pixmaps.verifier_to_testing_tool_icon_buffer
		end

	execute_generate_test_item (a_ce_init_state: E2B_INITIAL_STATE_OF_ROUTINE)
			-- Generate tests from proof failures
			-- local
			--	l_window: EB_DEVELOPMENT_WINDOW
		local
			l_dialog: ES_INFORMATION_PROMPT
		do
			last_execution := agent execute_generate_test_item
				-- generate_test_item.enable_select
				-- generate_minimized_test_item.disable_select
				-- generate_execution_trace_item.disable_select
				-- disable_tool_button

			print ("ES_PROOF2TEST_COMMAND.execute_generate_test_item%N")

			window_manager.display_message ("Test generation started")
			print("number of test cases: " + options.init_states_of_counterexamples.count.out + "%N")

			proof2test.generate_tests (options.init_states_of_counterexamples) -- generate a test for a single counterexample each time
			options.init_states_of_counterexamples.wipe_out
			-- proof2test.generate_test_for_ce (a_ce_init_state) -- TODO: generate tests for single ce
				-- create l_dialog.make_standard ("Proof2Test finished. See the generated test cases at " + proof2test.test_file_name.to_string_8)
				-- l_dialog.show_on_active_window
			eiffel_project.discover_melt
			window_manager.display_message ("Test generation finished. See the generated test cases at " + proof2test.test_file_name.to_string_8)

				-- enable_tool_button
		end

	execute_generate_fix_item
	       -- Generate possible fixes from counterexamples
		do
           last_execution := agent execute_generate_new_counterexample_item
				-- generate_minimized_test_item.enable_select
				-- generate_test_item.disable_select
				-- generate_execution_trace_item.disable_select
				-- disable_tool_button

			window_manager.display_message ("Generation of new counterexample started")

			options.set_generate_fix_enabled (True)

			verify_for_new_counterexample
			options.set_generate_new_counterexample_enabled (False)
		end

	execute_generate_minimal_counterexample_item
			-- Generate minimized tests from proof failures
		local
			l_window: EB_DEVELOPMENT_WINDOW
			dialog: ES_MINIMIZE_PARAMETER_DIALOG
		do
			create dialog.make_with_window (l_window)
			dialog.dialog.set_height (50)
			dialog.dialog.set_width (80)
			dialog.show_on_active_window

			last_execution := agent execute_generate_minimal_counterexample_item
				-- generate_minimized_test_item.enable_select
				-- generate_test_item.disable_select
				-- generate_execution_trace_item.disable_select
				-- disable_tool_button

			window_manager.display_message ("Minimization started")
			options.set_generate_minimal_counterexample_enabled (True)
				-- Pass the currently selected failure to option?
			verify_for_minimization
			options.set_generate_minimal_counterexample_enabled (False)
		end

	execute_generate_new_counterexample_item
			-- Generate minimized tests from proof failures
		do
			last_execution := agent execute_generate_new_counterexample_item
				-- generate_minimized_test_item.enable_select
				-- generate_test_item.disable_select
				-- generate_execution_trace_item.disable_select
				-- disable_tool_button

			window_manager.display_message ("Generation of new counterexample started")

			options.set_generate_new_counterexample_enabled (True)
				-- Pass the currently selected failure to option?
			verify_for_new_counterexample
			options.set_generate_new_counterexample_enabled (False)
		end

	execute_generate_minimized_test_item
			-- Generate minimized tests from proof failures
		local
			l_window: EB_DEVELOPMENT_WINDOW
			dialog: ES_MINIMIZE_PARAMETER_DIALOG
		do
			create dialog.make_with_window (l_window)
			dialog.dialog.set_height (50)
			dialog.dialog.set_width (80)
			dialog.show_on_active_window

			last_execution := agent execute_generate_minimized_test_item
				-- generate_minimized_test_item.enable_select
				-- generate_test_item.disable_select
				-- generate_execution_trace_item.disable_select
				-- disable_tool_button

			window_manager.display_message ("Proof2Test started")
				-- reverify to minimize test cases
			options.set_generate_minimal_counterexample_enabled (True)

				-- l_window := window_manager.last_focused_development_window

				-- record the stone used in the last verification
				-- if it's not Void, use the last stone for verification, otherwise use the currently focused stone

				-- if droppable (l_window.stone) then
				-- 	verify (l_window.stone)
				-- end
			verify_for_minimization

			options.set_generate_minimal_counterexample_enabled (False)
		end

	execute_last_action
			-- Execute same action as last time.
		do
			last_execution.call ([])
		end

feature {NONE} -- Implementation

	frozen service_consumer: SERVICE_CONSUMER [EVENT_LIST_S]
			-- Access to an event list service {EVENT_LIST_S} consumer.
		once
			create Result
		ensure
			result_attached: Result /= Void
		end

	frozen event_list: EVENT_LIST_S
			-- Access to an event list service.
		do
			check service_consumer.service /= Void end
			Result := service_consumer.service
		end

		-- set_up_menu_items
		--		-- Set up menu items of proof button
		--	do
		--		last_execution := agent execute_generate_test_item
		--		create generate_test_item.make_with_text_and_action ("Generate test", agent execute_generate_test_item)
		--		generate_test_item.toggle

		--		create generate_minimized_test_item.make_with_text_and_action ("Generate minimized test", agent execute_generate_minimized_test_item)
		-- create generate_execution_trace_item.make_with_text_and_action ("Generate execution trace", agent execute_proof_parent_cluster)

		--	end

		-- drop_down_menu: EV_MENU
		-- Drop down menu for `new_sd_toolbar_item'.
		--	once
		--		create Result
		--		Result.extend (generate_test_item)
		--		Result.extend (generate_minimized_test_item)
		-- Result.extend (generate_execution_trace_item)
		--	ensure
		--		not_void: Result /= Void
		--	end

	last_execution: PROCEDURE
			-- Last executed actions

		-- generate_test_item: EV_CHECK_MENU_ITEM
		-- Menu item for generating tests

		-- generate_minimized_test_item: EV_CHECK_MENU_ITEM
		-- Menu item for generating minimized tests

--	generate_execution_trace_item: EV_CHECK_MENU_ITEM
		-- Menu item to proof parent item

	menu_name: STRING_GENERAL
			-- Name as it appears in the menu (with & symbol).
		do
			Result := "Generate test"
		end

	tooltip: STRING_GENERAL
			-- Tooltip for the toolbar button.
		do
			Result := "Generate tests from proof failures."
		end

	tooltext: STRING_GENERAL
			-- Text for the toolbar button.
		do
			Result := "Generate test"
		end

	description: STRING_GENERAL
			-- Description for this command.
		do
			Result := "Generate tests from proof failures."
		end

	name: STRING_GENERAL
			-- Name of the command. Used to store the command in the
			-- preferences.
		do
			Result := "Diagnosis"
		end

	error: E2B_VERIFICATION_ERROR
			-- Currently analyzed proof error

	failure: E2B_FAILED_VERIFICATION
			-- Currently analyzed proof failure

	target_row: EV_GRID_ROW
			-- Target row

	;

note
	date: "$Date: 2022-01-19 14:42:23 +0800 (Wed, 19 Jan 2022) $"
	revision: "$Revision: 106121 $"
	copyright:
		"Copyright (c) 2012-2014 ETH Zurich",
		"Copyright (c) 2018 Politecnico di Milano",
		"Copyright (c) 2021-2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Alexander Kogtenkov"
	license: "GNU General Public License"
	license_name: "GPL"
	EIS: "name=GPL", "src=https://www.gnu.org/licenses/gpl.html", "tag=license"
	copying: "[
					This program is free software; you can redistribute it and/or modify it under the terms of
					the GNU General Public License as published by the Free Software Foundation; either version 1,
					or (at your option) any later version.
			
					This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
					without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
					See the GNU General Public License for more details.
			
					You should have received a copy of the GNU General Public License along with this program.
					If not, see <https://www.gnu.org/licenses/>.
		]"

end
