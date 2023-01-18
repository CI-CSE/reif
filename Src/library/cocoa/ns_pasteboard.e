note
	description: "Summary description for {NS_PASTEBOARD}."
	author: "Daniel Furrer"
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $"
	revision: "$Revision: 92557 $"

class
	NS_PASTEBOARD

inherit
	NS_OBJECT

create
	general_pasteboard

feature -- Creating and Releasing a Pasteboard

	general_pasteboard
		do
			
		end

feature -- Getting a Pasteboard's Name

feature -- Writing Data

feature -- Reading Data

feature -- Determining Types

feature -- Noticing Changed Ownership

end
