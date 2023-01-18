note
	description: "Summary description for {WEB_SOCKET_SERVICE}."
	date: "$Date: 2016-10-18 20:02:52 +0800 (周二, 18 10月 2016) $"
	revision: "$Revision: 99306 $"

class
	WEB_SOCKET_SERVICE [G -> WEB_SOCKET_EXECUTION create make end]

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			l_launcher: WSF_STANDALONE_WEBSOCKET_SERVICE_LAUNCHER [G]
			opts: WEB_SOCKET_SERVICE_OPTIONS
		do
			create opts
			set_options (opts)
			opts.append_options (create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI}.make_from_file ("ws.ini"))
			create l_launcher.make_and_launch (opts)
		end

	set_options (opts: WEB_SOCKET_SERVICE_OPTIONS)
			-- Set values on `opts'.
		do
		end

end
