note
	description: "DEMO application server."
	date: "$Date: 2018-11-13 18:34:58 +0800 (周二, 13 11月 2018) $"
	revision: "$Revision: 102436 $"

class
	DEMO_CMS_SERVER

inherit
	ROC_CMS_LAUNCHER [DEMO_CMS_EXECUTION]
		redefine
			optional_application_name
		end

create
	make_and_launch

feature -- Access	

	optional_application_name: STRING_32 = "server"

end

