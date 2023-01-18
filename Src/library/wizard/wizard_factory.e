note
	description: "Factory for creating initial state of wizard and information."
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

deferred class
	WIZARD_FACTORY

feature -- Factory

	new_wizard_initial_state: WIZARD_STATE_WINDOW
			-- New initial state for wizard.
		deferred
		ensure
			new_wizard_initial_state_not_void: Result /= Void
		end

end
