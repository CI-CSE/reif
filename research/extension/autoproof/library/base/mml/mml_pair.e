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
--			default_create,
			is_equal,
			out
		end

create
	make

feature {NONE} -- Initialization

	make (x: G; y: H)
			-- Create a pair (`x', `y').
		do
			priv_left := x
			priv_right := y
		end

feature {NONE} -- Fields
	priv_left: G
	priv_right: H

feature -- Access

	left: G -- Left component.
		note
			maps_to: "Pair#Left"
		do
			Result := priv_left
		end

	right: H -- Right component.
		note
			maps_to: "Pair#Right"
		do
			Result := priv_right
		end

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
