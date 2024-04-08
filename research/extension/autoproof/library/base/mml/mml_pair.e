note
	description: "Pairs."
	author: "Nadia Polikarpova"
	revised_by: "Alexander Kogtenkov"
	theory: "pair.bpl"
	maps_to: "Pair"
	type_properties: "Pair#LeftType", "Pair#RightType"

class MML_PAIR [G, H]

inherit
	ANY
		redefine
			is_equal,
			out
		end

create
	make

feature {NONE} -- Initialization

	make (x: G; y: H)
			-- Create a pair (`x', `y').
		do
			left := x
			right := y
		end

feature -- Access

	left: G -- Left component.

	right: H -- Right component.

feature -- io
	out: STRING
		do
			Result := "NA"
			if attached {ANY} left as att_left ∧ attached {ANY} right as att_right then
				Result := "[" + att_left.out + ", " + att_right.out  + "]"
			end
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same pair as `Current'?
		note
			maps_to: "Pair#Equal"
		do
			Result := (left = a_other.left) ∧ (right = a_other.right)
		end

end
