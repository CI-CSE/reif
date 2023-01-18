note
	description: "Summary description for {AFX_SHARED_SERVER_VARIABLES_IN_SCOPE}."
	author: ""
	date: "$Date: 2013-10-17 18:01:19 +0800 (Thu, 17 Oct 2013) $"
	revision: "$Revision: 93135 $"

deferred class
	EPA_SHARED_SERVER_VARIABLES_IN_SCOPE

inherit
	ANY
		undefine
			is_equal,
			copy
		end

feature -- Access

	server_variables_in_scope: EPA_SERVER_VARIABLES_IN_SCOPE
			-- Shared server.
		do
			Result := server_variables_in_scope_cell.item
		end

feature -- Status set

	set_server_variables_in_scope (a_server: EPA_SERVER_VARIABLES_IN_SCOPE)
			-- Set `server_variables_in_scope'.
		do
			server_variables_in_scope_cell.put (a_server)
		end

feature{NONE} -- Storage

	server_variables_in_scope_cell: CELL [EPA_SERVER_VARIABLES_IN_SCOPE]
			-- Storage for `server_variables_in_scope'.
		once
			create Result.put (create {EPA_SERVER_VARIABLES_IN_SCOPE})
		end

end
