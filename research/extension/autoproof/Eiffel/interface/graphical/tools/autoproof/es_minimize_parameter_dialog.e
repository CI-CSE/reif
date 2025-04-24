note
	description: "Dialog to select docking layout names for saving."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2018-10-04 04:29:07 +0800 (�%/145/��%/155/%/155/, 04 10�%/156/%/136/ 2018) $"
	revision: "$Revision: 102278 $"

class
	ES_MINIMIZE_PARAMETER_DIALOG

inherit
	ES_DIALOG

	EB_CONSTANTS
		rename
			interface_names as interface_names_from_constants,
			interface_messages as interface_messages_from_constants
		undefine
			default_create,
			copy
		end

	E2B_SHARED_CONTEXT

create
	make_with_window

feature {NONE} -- Initlization

	build_dialog_interface (a_container: EV_VERTICAL_BOX)
			-- <Precursor>
		do
			create manager.make (internal_development_window)
			init_widgets (a_container)
		end

	init_widgets (a_container: EV_VERTICAL_BOX)
			-- Initilalize widgets.
		require
			not_void: a_container /= Void
		local
			l_h_box: EV_HORIZONTAL_BOX
			l_internal_h_box: EV_HORIZONTAL_BOX
			l_tool_bar: SD_TOOL_BAR
		do

			a_container.set_border_width (layout_constants.default_border_size)
			a_container.set_padding (Layout_constants.Default_padding_size)

			create l_h_box
			a_container.extend (l_h_box)
			a_container.disable_item_expand (l_h_box)

			create label_for_tolerance
			label_for_tolerance.set_text ("Proof2Test runs proofs iteratively to get minimum integer values of test input.%NTolerance and Maximum Iterations decide when to stop iteration.")
			label_for_tolerance.align_text_left
			l_h_box.extend (label_for_tolerance)
			l_h_box.disable_item_expand (label_for_tolerance)

			create l_h_box
			l_h_box.set_padding (layout_constants.Default_padding_size)
			a_container.extend (l_h_box)
			a_container.disable_item_expand (l_h_box)

			create tolerance_label_name
			tolerance_label_name.set_text ("Tolerance")
			tolerance_label_name.set_tooltip ("Lower bound on the size of interval in the binary search algorithm.")
			l_h_box.extend (tolerance_label_name)
			l_h_box.disable_item_expand (tolerance_label_name)

			create text_for_tolerance
			text_for_tolerance.set_text ("0")
			text_for_tolerance.change_actions.extend (agent on_text_change)
			text_for_tolerance.key_press_actions.extend (agent on_text_key_press)
			l_h_box.extend (text_for_tolerance)

			create max_iteration_label_name
			max_iteration_label_name.set_text ("Maximum Iterations")
			max_iteration_label_name.set_tooltip ("Maximum number of iterations allowed when minimizing an integer.")
			l_h_box.extend (max_iteration_label_name)
			l_h_box.disable_item_expand (max_iteration_label_name)

			create text_for_max_iteration
			text_for_max_iteration.set_text ("64")
			text_for_max_iteration.change_actions.extend (agent on_text_change)
			text_for_max_iteration.key_press_actions.extend (agent on_text_key_press)
			l_h_box.extend (text_for_max_iteration)

			create l_tool_bar.make
			l_tool_bar.compute_minimum_size
			l_h_box.extend (l_tool_bar)
			l_h_box.disable_item_expand (l_tool_bar)

			dialog_window_buttons.item ({ES_DIALOG_BUTTONS}.ok_button).enable_sensitive
			set_button_action_before_close ({ES_DIALOG_BUTTONS}.ok_button, agent on_ok)

			show_actions.extend_kamikaze (agent text_for_tolerance.set_focus)

			create l_internal_h_box
			create minimize_strategy_label_name
			minimize_strategy_label_name.set_text ("Minimize strategy%T")
			l_internal_h_box.extend (minimize_strategy_label_name)
			l_internal_h_box.disable_item_expand (minimize_strategy_label_name)

			create evcombo_minimize_strategy.make_with_strings (<<"Minimize sum", "Minimize in turn">>)
			evcombo_minimize_strategy.disable_edit
			l_internal_h_box.extend (evcombo_minimize_strategy)
			a_container.extend (l_internal_h_box)
			evcombo_minimize_strategy.set_minimum_width (20)

		end

feature {NONE} -- Implementation functions

	on_text_change
			-- On `text_for_name' texts changed
		do
			if text_for_tolerance.text /= Void and then not text_for_tolerance.text.is_equal ("") then
				dialog_window_buttons.item ({ES_DIALOG_BUTTONS}.ok_button).enable_sensitive
			else
				dialog_window_buttons.item ({ES_DIALOG_BUTTONS}.ok_button).disable_sensitive
			end
		end

	on_ok
			-- On `ok' button pressed.
		do
			if text_for_tolerance.text.is_integer and then text_for_tolerance.text.to_integer > 0 then
				options.set_minimization_tolerance (text_for_tolerance.text.to_integer)
			else
				options.set_minimization_tolerance (0)
			end

			if text_for_max_iteration.text.is_integer and then text_for_max_iteration.text.to_integer > 0 then
				options.set_minimization_iteration_bound (text_for_max_iteration.text.to_integer)
			else
				options.set_minimization_iteration_bound (20)
			end

			if evcombo_minimize_strategy.text.same_string ("Minimize sum") then
				options.set_is_minimize_sum (True)
			end

		end

	on_overwirte_and_destroy (a_name: STRING_GENERAL)
			-- Handle overwrite and destroy actions.
		local
			l_result: BOOLEAN
		do
			l_result := manager.add_layout (a_name)
			if not l_result then
				show_last_error
			end
		end

	on_text_key_press (a_key: EV_KEY)
			-- Handle key press actions.
		do
			inspect
				a_key.code
			when {EV_KEY_CONSTANTS}.key_enter then
				if text_for_tolerance.text /= Void and then not text_for_tolerance.text.is_equal ("") then
					on_ok
				end
			else

			end
		end

	show_last_error
			-- Show last exception error
		local
			l_information: ES_PROMPT_PROVIDER
			l_exception: EXCEPTION_MANAGER
			l_tag: detachable READABLE_STRING_GENERAL
		do
			create l_exception
			l_tag := l_exception.last_exception.tag
			if l_tag = Void then
				l_tag := interface_names.l_unknown_error
			end
			create l_information
			l_information.show_error_prompt (interface_names.l_saving_docking_data_error (l_tag), dialog, void)
		end

feature {NONE} -- Implementation

	manager: EB_NAMED_LAYOUT_MANAGER
			-- Named layout manager.

	vertical_box: EV_VERTICAL_BOX
			-- Vertical box

	label_for_tolerance: EV_LABEL
			-- Label for tolerance.

	tolerance_label_name: EV_LABEL
			-- Label beside `text_for_tolerance'

	max_iteration_label_name: EV_LABEL
			-- Label beside `maximum iteration text'

	minimize_strategy_label_name: EV_LABEL
			-- Label beside `minimize strategy combo'

	text_for_tolerance: EV_TEXT_FIELD
			-- Text for tolerance.

	text_for_max_iteration: EV_TEXT_FIELD
			-- Text for tolerance.


feature -- Access

	icon: EV_PIXEL_BUFFER
			-- The dialog's icon
		do
			Result := stock_pixmaps.general_dialog_icon_buffer
		end

	title: STRING_32
			-- The dialog's title
		do
			Result := "Minimization parameters"
		end

	buttons: DS_SET [INTEGER]
			-- Set of button id's for dialog
			-- Note: Use {ES_DIALOG_BUTTONS} or `dialog_buttons' to determine the id's correspondance.
		once
			Result := dialog_buttons.ok_cancel_buttons
		end

	default_button: INTEGER
			-- The dialog's default action button
		once
			Result := dialog_buttons.ok_button
		end

	default_cancel_button: INTEGER
			-- The dialog's default cancel button
		once
			Result := dialog_buttons.cancel_button
		end

	default_confirm_button: INTEGER
			-- The dialog's default confirm button
		once
			Result := dialog_buttons.ok_button
		end

	evcombo_minimize_strategy: EV_COMBO_BOX
			-- Strategies used for minimization

;
note
	copyright: "Copyright (c) 1984-2018, Eiffel Software"
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
