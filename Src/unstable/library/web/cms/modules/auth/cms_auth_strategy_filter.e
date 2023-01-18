note
	description: "Summary description for {CMS_AUTH_FILTER_WITH_LOGOUT}."
	author: ""
	date: "$Date: 2020-07-08 16:34:02 +0800 (周三, 08 7月 2020) $"
	revision: "$Revision: 104533 $"

deferred class
	CMS_AUTH_STRATEGY_FILTER

inherit
	CMS_AUTH_FILTER
		redefine
			set_current_user,
			set_current_inactive_user
		end

feature -- Basic operations

	auth_strategy: STRING
		deferred
		end

	set_current_user (u: CMS_USER)
		do
			Precursor (u)
				-- Record auth strategy:
			api.set_execution_variable ({CMS_AUTHENTICATION_MODULE}.auth_strategy_execution_variable_name, auth_strategy)
		end

	set_current_inactive_user (u: CMS_USER)
		do
			Precursor (u)
				-- Record auth strategy:
			api.set_execution_variable ({CMS_AUTHENTICATION_MODULE}.auth_strategy_execution_variable_name, auth_strategy)
		end

end
