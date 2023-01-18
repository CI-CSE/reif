note
	description: "[
			Interface helping using SSL.
			For now, mainly for `is_secure_connection_supported' to indicate if current project is compiled with SSL support.
			i.e compiled with EiffelNet-SSL library.
		]"
	date: "$Date: 2016-10-18 20:02:52 +0800 (周二, 18 10月 2016) $"
	revision: "$Revision: 99306 $"

class
	HTTP_SECURE_HELPER

feature -- Status

	is_secure_connection_supported: BOOLEAN = False
			-- Is Current system compiled with EiffelNet-SSL support?

end
