note
	description: "[
			Common ancestor for builders responsible to instantiate storage based
			on SQL statement storage.
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2017-02-08 01:57:08 +0800 (周三, 08 2月 2017) $"
	revision: "$Revision: 99795 $"

deferred class
	CMS_STORAGE_SQL_BUILDER

inherit
	CMS_STORAGE_BUILDER

feature -- Initialization

	initialize (a_setup: CMS_SETUP; a_storage: CMS_STORAGE_SQL)
		do
				-- Eventually custom database initialization...
		end

note
	copyright: "2011-2017, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
