note
	description: "Summary description for {ES_UPDATE_CONSTANTS}."
	date: "$Date: 2020-12-31 01:53:43 +0800 (周四, 31 12月 2020) $"
	revision: "$Revision: 105073 $"

class
	ES_UPDATE_CONSTANTS

feature -- Access

	update_service_url: STRING = "https://account.eiffel.com"
			-- Official Eiffel.org site url.

	beta_channel: STRING = "beta"
			-- Update Service beta channel.

	stable_channel: STRING = "stable"
			-- Update service stable channel.

end
