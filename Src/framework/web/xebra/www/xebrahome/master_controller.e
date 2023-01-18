note
	description: "[
		Provides features for the servlets
	]"
	legal: "See notice at end of class."
	date: "$Date: 2013-02-05 05:27:38 +0800 (周二, 05 2月 2013) $"
	revision: "$Revision: 91160 $"

class
	MASTER_CONTROLLER

inherit
	XWA_CONTROLLER redefine	make end

create
	make

feature {NONE} -- Initialization	

	make
			-- Initializes Current
		do
			Precursor
		end
end
