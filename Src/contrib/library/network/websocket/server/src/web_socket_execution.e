note
	description: "Summary description for {WEB_SOCKET_EXECUTION}."
	date: "$Date: 2016-10-18 20:02:52 +0800 (周二, 18 10月 2016) $"
	revision: "$Revision: 99306 $"

deferred class
	WEB_SOCKET_EXECUTION

inherit
	WSF_WEBSOCKET_EXECUTION

	WEB_SOCKET_EVENT_I

feature -- Websocket execution

	new_websocket_handler (ws: WEB_SOCKET): WEB_SOCKET_HANDLER
		do
			create Result.make (ws, Current)
		end

end
