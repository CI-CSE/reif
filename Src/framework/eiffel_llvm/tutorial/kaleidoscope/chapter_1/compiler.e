note
	description : "kaleidoscope application root class"
	date        : "$Date: 2015-05-30 03:38:29 +0800 (周六, 30 5月 2015) $"
	revision    : "$Revision: 97409 $"

class
	COMPILER

inherit
	ARGUMENTS

create
	make

feature {NONE} -- Initialization

	make
			-- Run application.
		do
			--| Add your code here
			print ("Hello Eiffel World!%N")
		end

end
