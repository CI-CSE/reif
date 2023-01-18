note
	description: "Summary description for {SHARED_SPECIAL}."
	author: ""
	date: "$Date: 2013-12-14 08:20:32 +0800 (周六, 14 12月 2013) $"
	revision: "$Revision: 93724 $"

class
	SHARED_SPECIAL

create
	make

feature

	special: SPECIAL [INTEGER]

	make (a_special: like special)
		do
			special := a_special
		end

end
