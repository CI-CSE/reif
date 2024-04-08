note
	description: "Finite relations."
	author: "Nadia Polikarpova"
	revised_by: "Alexander Kogtenkov"
	theory: "relation.bpl", "set.bpl", "pair.bpl"
	maps_to: "Rel"
	type_properties: "Rel#DomainType", "Rel#RangeType"

class
	MML_RELATION [G, H]

inherit
	ITERABLE [MML_PAIR [G, H]]
		redefine
			default_create,
			is_equal,
			out
		end

create
	default_create,
	singleton,
	make_from_arrays,
	make_from_set

feature -- io
	out: STRING
		do
			Result := to_set.out
		end

feature {NONE} -- Initialization

	default_create
			-- Create an empty relation.
		note
			maps_to: "Rel#Empty"
		do
			create lefts.make (1, 0)
			create rights.make (1, 0)
		end

	singleton (x: G; y: H)
			-- Create a relation with just one pair <`x', `y'>.
		do
			create lefts.make_filled (x, 1, 1)
			create rights.make_filled (y, 1, 1)
		end

	make_from_arrays (ls: ARRAY [G]; rs: ARRAY [H])
			-- Create with predefined arrays.
		require
			same_lower: ls.lower = rs.lower
			same_upper: ls.upper = rs.upper
			start_from_one: ls.lower = 1
		do
			lefts := ls
			rights := rs
		end


	make_from_set (set: MML_SET [MML_PAIR [G, H]])
		local
			l_lefts: ARRAY [G]
			l_rights: ARRAY [H]
			as_array: ARRAY [MML_PAIR [G, H]]
			i: INTEGER
		do
			as_array := set.to_array

			create l_lefts.make_empty
			create l_rights.make_empty
			l_lefts.grow (as_array.count)
			l_rights.grow (as_array.count)

			from i := 1
			until i > as_array.count
			loop
				l_lefts [i] := as_array [i].left
				l_rights [i] := as_array [i].right
				i := i + 1
			end
			lefts := l_lefts
			rights := l_rights
		end

feature -- Properties

	has alias "[]" (x: G; y: H): BOOLEAN
			-- Is `x' related `y'?
		note
			maps_to: "[]"
		local
			i: INTEGER
		do
			Result := to_set.has (create {MML_PAIR [G, H]}.make (x, y))
		end

	is_empty: BOOLEAN
			-- Is map empty?
		do
			Result := lefts.is_empty
		end

feature -- Sets

	domain: MML_SET [G]
			-- The set of left components.
		local
			i: INTEGER
		do
			create Result
			from
				i := 1
			until
				i > lefts.count
			loop
				Result := Result & lefts [i]
				i := i + 1
			end
		end

	range: MML_SET [H]
			-- The set of right components.
		local
			i: INTEGER
		do
			create Result
			from
				i := 1
			until
				i > rights.count
			loop
				Result := Result & rights [i]
				i := i + 1
			end
		end

	to_set: MML_SET [MML_PAIR [G, H]]
			-- Relation as a set of pairs.
		local
			i: INTEGER
		do
			create Result
			from
				i := 1
			until
				i > lefts.count
			loop
				Result := Result & (create {MML_PAIR [G, H]}.make (lefts [i], rights [i]))
				i := i + 1
			end
		end

	image_of (x: G): MML_SET [H]
			-- Set of values related to `x'.
		do
				-- check is_executable: False then end
			Result := image (create {MML_SET [G]}.singleton (x))
		end

	image (subdomain: MML_SET [G]): MML_SET [H]
			-- Set of values related to any value in `subdomain'.
		do
				-- check is_executable: False then end
			Result := restricted (subdomain).range
		end

feature -- Measurement

	count: INTEGER
			-- Cardinality.
		note
			maps_to: "Rel#Card"
		do
			Result := lefts.count
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same relation as `Current'?
		note
			maps_to: "Rel#Equal"
		local
			i: INTEGER
		do
			if attached {MML_RELATION [G, H]} a_other as rel and then count = rel.count then
				from
					Result := True
					i := 1
				until
					i > lefts.count or not Result
				loop
					Result := rel [lefts [i], rights [i]]
					i := i + 1
				end
			end
		end

feature -- Modification

	extended (x: G; y: H): MML_RELATION [G, H]
			-- Current relation extended with pair (`x', `y') if absent.
		local
			ls: ARRAY [G]
			rs: ARRAY [H]
		do
			if not Current [x, y] then
				create ls.make (1, lefts.count + 1)
				ls.subcopy (lefts, 1, lefts.count, 1)
				ls [ls.count] := x
				create rs.make (1, rights.count + 1)
				rs.subcopy (rights, 1, rights.count, 1)
				rs [rs.count] := y
				create Result.make_from_arrays (ls, rs)
			else
				Result := Current
			end
		end

	first_left_index (k: G): INTEGER
		local
			i: INTEGER
		do
			from
				i := 1 -- index starts from 1
			until
				lefts [i] ~ k or i > lefts.count
			loop
				i := i + 1
			end

			if i <= lefts.count then
				Result := i
			end
		end

	removed (x: G; y: H): MML_RELATION [G, H]
			-- Current relation with pair (`x', `y') removed if present.
		local
			ls: ARRAY [G]
			rs: ARRAY [H]
			i: INTEGER
		do
			i := first_left_index (x)
			if i > 0 then -- TODO: incompatible actual argument: and then model_equals (y, rights [i]) then
				create ls.make (1, lefts.count - 1)
				ls.subcopy (lefts, 1, i - 1, 1)
				ls.subcopy (lefts, i + 1, lefts.count, i)
				create rs.make (1, rights.count - 1)
				rs.subcopy (rights, 1, i - 1, 1)
				rs.subcopy (rights, i + 1, rights.count, i)
				create Result.make_from_arrays (ls, rs)
			else
				Result := Current
			end
		end

	restricted alias "|" alias "/" (subdomain: MML_SET [G]): MML_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose left component is in `subdomain'.
		local
			ls: ARRAY [G]
			rs: ARRAY [H]
			i, j: INTEGER
		do
			create ls.make (1, lefts.count)
			create rs.make (1, rights.count)
			from
				i := 1
				j := 1
			until
				i > lefts.count
			loop
				if subdomain [lefts [i]] then
					ls [j] := lefts [i]
					rs [j] := rights [i]
					j := j + 1
				end
				i := i + 1
			end
			ls.keep_head (j - 1)
			rs.keep_head (j - 1)
			create Result.make_from_arrays (ls, rs)
		ensure
			Result.to_set ⊆ to_set
		end

	restircted_by_target alias "\" (subimage: MML_SET [H]): MML_RELATION [G, H]
			-- Relation that consists of all pairs in `Current' whose right component is in `subimage'.
		do
			Result := (inverse / subimage).inverse
		end

	inverse: MML_RELATION [H, G]
			-- Relation that consists of inverted pairs from `Current'.
		do
			create Result.make_from_arrays (rights, lefts)
		end

	union alias "+" alias "∪" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other'.
		do
			Result := Current - other
			Result.lefts.resize (1, Result.lefts.count + other.lefts.count)
			Result.rights.resize (1, Result.rights.count + other.rights.count)
			Result.lefts.subcopy (other.lefts, 1, other.lefts.count, Result.lefts.count - other.count + 1)
			Result.rights.subcopy (other.rights, 1, other.rights.count, Result.rights.count - other.count + 1)
		end

	intersection alias "*" alias "∩" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in both `Current' and `other'.
		local
			ls: ARRAY [G]
			rs: ARRAY [H]
			i, j: INTEGER
		do
			create ls.make (1, lefts.count)
			create rs.make (1, rights.count)
			from
				i := 1
				j := 1
			until
				i > lefts.count
			loop
				if other [lefts [i], rights [i]] then
					ls [j] := lefts [i]
					rs [j] := rights [i]
					j := j + 1
				end
				i := i + 1
			end
			ls.keep_head (j - 1)
			rs.keep_head (j - 1)
			create Result.make_from_arrays (ls, rs)
		end

	difference alias "-" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in `Current' but not in `other'.
		local
			ls: ARRAY [G]
			rs: ARRAY [H]
			i, j: INTEGER
		do
			create ls.make (1, lefts.count)
			create rs.make (1, rights.count)
			from
				i := 1
				j := 1
			until
				i > lefts.count
			loop
				if not other [lefts [i], rights [i]] then
					ls [j] := lefts [i]
					rs [j] := rights [i]
					j := j + 1
				end
				i := i + 1
			end
			ls.keep_head (j - 1)
			rs.keep_head (j - 1)
			create Result.make_from_arrays (ls, rs)
		end

	sym_difference alias "^" (other: MML_RELATION [G, H]): MML_RELATION [G, H]
			-- Relation that consists of pairs contained in either `Current' or `other', but not in both.
		do
			Result := (Current + other) - (Current * other)
		end

feature -- Attributes
	is_function: BOOLEAN
		do
			Result := domain.count = lefts.count
		ensure
			Result ⇒ ∀d: domain ¦ image_of(d).count = 1
			¬Result ⇒ ∃d: domain ¦ image_of(d).count > 1
		end

feature -- Iterable implementation

	lefts: ARRAY [G]
			-- Storage for the left components of pairs.

	rights: ARRAY [H]
			-- Storage for the right components of pairs.

	meq_left (v1, v2: ANY): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end

	meq_right (v1, v2: ANY): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end

	new_cursor: ITERATION_CURSOR [MML_PAIR [G, H]]
			-- <Precursor>
		note
			maps_to: "Rel#ToSet"
		do
			Result := to_set.new_cursor
		end

feature -- Convenience

	empty_relation: MML_RELATION [G, H]
			-- Empty relation.
			-- Can be used as `{MML_RELATION [G]}.empty_relation'.
		note
			maps_to: "Rel#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

invariant
	same_lower: lefts.lower = rights.lower
	same_upper: lefts.upper = rights.upper
	start_from_one: lefts.lower = 1

end
