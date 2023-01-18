note
	description: "Summary description for {DER_ENCODING}."
	author: ""
	date: "$Date: 2011-11-12 01:13:16 +0800 (周六, 12 11月 2011) $"
	revision: "$Revision: 87787 $"

class
	DER_ENCODING

inherit
	DEVELOPER_EXCEPTION

create
	make

feature
	make (reason_a: STRING)
		do
			reason := reason_a
		end

feature
	reason: STRING
end
