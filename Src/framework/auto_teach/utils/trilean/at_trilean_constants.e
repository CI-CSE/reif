note
	description: "Constants of the three possible values for trileans."
	author: "Paolo Antonucci"
	date: "$Date: 2014-09-04 05:53:05 +0800 (Thu, 04 Sep 2014) $"
	revision: "$Revision: 95741 $"

class
	AT_TRILEAN_CONSTANTS

feature {NONE} -- Constants

	Tri_true: AT_TRILEAN
			-- True value
		once ("PROCESS")
			create Result.make_defined (True)
		end

	Tri_false: AT_TRILEAN
			-- False value
		once ("PROCESS")
			create Result.make_defined (False)
		end

	Tri_undefined: AT_TRILEAN
			-- Undefined value
		once ("PROCESS")
			create Result.make_undefined
		end

end
