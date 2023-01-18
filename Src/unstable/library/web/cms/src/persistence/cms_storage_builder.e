note
	description: "[
			Objects that ...
		]"
	author: "$Author: jfiat $"
	date: "$Date: 2020-06-03 03:38:41 +0800 (周三, 03 6月 2020) $"
	revision: "$Revision: 104403 $"

deferred class
	CMS_STORAGE_BUILDER

feature -- Factory

	storage (a_db_cfg: DATABASE_CONFIGURATION; a_setup: CMS_SETUP; a_error_handler: ERROR_HANDLER): detachable CMS_STORAGE
			-- CMS Storage object based on CMS setup `a_setup'.
		deferred
		end

note
	copyright: "2011-2020, Jocelyn Fiat, Javier Velilla, Eiffel Software and others"
	license: "Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
end
