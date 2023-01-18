note
	description: ""
	date: "$Date: 2016-01-22 17:34:21 +0800 (周五, 22 1月 2016) $"
	revision: "$Revision: 98410 $"

deferred class
	EDK_MESSAGE_SENDER

inherit
	EDK_OBJECT_I

feature -- Access

	message_manager: EDK_MESSAGE_MANAGER
		require
			message_manager_available: message_manager_available
		do
			check
				from_precondition: attached message_manager_cell.item as m
			then
				Result := m
			end
		end

	message_manager_available: BOOLEAN
			-- Is the message manager available?
		do
			Result := message_manager_cell.item /= Void
		end

feature {NONE} -- Implementation

	message_manager_cell: CELL [detachable EDK_MESSAGE_MANAGER]
		once ("PROCESS")
			Result := create {CELL [detachable EDK_MESSAGE_MANAGER]}.put (Void)
		end

note
	copyright: "Copyright (c) 1984-2016, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
