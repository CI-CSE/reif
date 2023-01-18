note
	description: "Summary description for {EPA_SHARED_MATH}."
	author: ""
	date: "$Date: 2010-06-16 04:44:45 +0800 (Wed, 16 Jun 2010) $"
	revision: "$Revision: 83582 $"

class
	EPA_SHARED_MATH

feature -- Math operations

	factorial (k: INTEGER): INTEGER
			-- Factorial of `k'
		local
			i: INTEGER
		do
			from
				Result := 1
				i := 1
			until
				i > k
			loop
				Result := Result * i
				i := i + 1
			end
		end

end
