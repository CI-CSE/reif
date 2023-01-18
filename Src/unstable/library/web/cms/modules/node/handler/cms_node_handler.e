note
	description: "Summary description for {CMS_NODE_HANDLER}."
	author: ""
	date: "$Date: 2015-04-30 16:41:13 +0800 (周四, 30 4月 2015) $"
	revision: "$Revision: 97217 $"

deferred class
	CMS_NODE_HANDLER

inherit
	CMS_MODULE_HANDLER [CMS_NODE_API]
		rename
			module_api as node_api
		end

end
