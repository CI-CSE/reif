note
	description: "Eiffel Vision radio button. Cocoa implementation."
	author:	"Daniel Furrer"
	date: "$Date$"
	revision: "$Revision$"

class
	EV_RADIO_BUTTON_IMP

inherit
	EV_RADIO_BUTTON_I
		redefine
			interface
		end

	EV_BUTTON_IMP
		undefine
			default_alignment
		redefine
			interface,
			make,
			old_make
		end

	EV_RADIO_PEER_IMP
		redefine
			interface,
			make
		end

create
	make

feature {NONE} -- Initialization

	old_make (an_interface: attached like interface)
			-- Create radio button.
		do
			assign_interface (an_interface)
		end

	make
			-- Initialize `Current'
		do
			cocoa_view := Current
			Precursor {EV_RADIO_PEER_IMP}
			Precursor {EV_BUTTON_IMP}
				-- NSRadioButton = 4
			set_button_type_ (4)
			align_text_left
				-- NSOnState
			set_state_ (1)
			select_actions.extend (agent enable_select)
		end

feature -- Status setting

	enable_select
			-- Select `Current'.
		do
				-- NSOnState = 1
			set_state_ (1)
		end

	disable_select
			-- Unselect 'Current'
		do
				-- NSOffState = 0
			set_state_ (0)
		end

feature -- Status report

	is_selected: BOOLEAN
			-- Is `Current' selected.
		do
				-- NSOnState = 1
			Result := state = 1
		end

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_RADIO_BUTTON note option: stable attribute end;

note
	copyright: "Copyright (c) 1984-2017, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end -- class EV_RADIO_BUTTON_IMP
