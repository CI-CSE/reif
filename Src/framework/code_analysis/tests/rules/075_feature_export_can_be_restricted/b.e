note
	description: "Summary description for {B}."
	author: ""
	date: "$Date: 2015-03-23 11:09:39 +0800 (周一, 23 3月 2015) $"
	revision: "$Revision: 96896 $"

class
	B

inherit
	A
	rename
		foo as bla
	end


feature

	foo: INTEGER
		do
			a2.foo
			bla
			b.a2.foo
			Result := b.foo
			Result := blu
		end

	a2: A
		do

		end

	b: B

	blu: INTEGER
		do

		end
end
