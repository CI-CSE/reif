note
	description: "Finite sequence."
	author: "Nadia Polikarpova"
	revised_by: "Alexander Kogtenkov"
	theory: "sequence.bpl", "map.bpl", "relation.bpl", "bag.bpl", "set.bpl", "pair.bpl"
	maps_to: "Seq"
	type_properties: "Seq#ItemsType"
	explicit: wrapping

class
	MML_SEQUENCE [G]

inherit
	ITERABLE [G]
		redefine
			default_create,
			is_equal
		end

create
	default_create,
	singleton,
	constant,
	-- Li
	make_from_array

convert
	singleton ({attached G})

feature {NONE} -- Initialization

	default_create
			-- Create an empty sequence.
		note
			maps_to: "Seq#Empty"
		do
			create array.make(1, 0)
		end

	singleton (x: G)
			-- Create a sequence with one element `x'.
		do
			create array.make_filled (x, 1, 1)
		end

	constant (x: G; n: INTEGER)
			-- Create a sequence with n copies of `x'.
		require
			n_non_negative: n >= 0
		do
			create array.make_filled (x, 1, n)
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := array.has (x)
		end

	is_empty: BOOLEAN
			-- Is the sequence empty?
		do
			Result := count = 0
		ensure
		    Result = (count = 0)
		end

	is_constant (c: G): BOOLEAN
			-- Are all values equal to `c'?
		local
			i: INTEGER
		do
			if attached array as arr then
				from
					i := 1
					Result := True
				until
					i > array.count or Result = False
				loop
					Result := arr [i] ~ c
					i := i + 1
				end
			end
		end

--	is_sorted: BOOLEAN
--			-- Is the sequence sorted?
--			-- (used for demo)
--		do
--		end

feature -- Elements

	item alias "[]" (i: INTEGER): G
			-- Value at position `i'.
		require
			in_domain: 1 <= i and i <= count
		do
			-- check is_executable: False then end
			Result := array [i]
		end

feature -- Conversion

	--Li domain: MML_SET [INTEGER]
	domain: MML_INTERVAL
			-- Set of indexes.
		do
			-- check is_executable: False then end
			create Result.from_range (1, count)
		end

	range: MML_SET [G]
			-- Set of values.
		local
			i: INTEGER
		do
		-- check is_executable: False then end
		    create Result
			from
				i := 1
			until
				i > array.count
			loop
				Result := Result & array [i]
				i := i + 1
			end
		end

	to_map: MML_MAP [INTEGER, G]
			-- Sequence viewed as a map from indexes to value.
		do
			check is_executable: False then end
		end

	to_bag: MML_BAG [G]
			-- Bag of sequence values.
		local
			i: INTEGER
		do
			-- check is_executable: False then end
			from
				create Result
				i := 1
			until
				i > array.count
			loop
				Result := result & array [i]
				i := i + 1
			end
		end

feature -- Measurement

	count alias "#": INTEGER
			-- Number of elements.
		note
			maps_to: "Seq#Length"
		do
			Result := array.count
		end

	occurrences (x: G): INTEGER
			-- How many times does `x' occur?
		do
			Result := array.occurrences (x)
		end

	index_of (x: G): INTEGER
			-- Position of some occurrence of `x'; out of bounds if `x' does not occur.
		do
			Result := array.area.index_of (x, 1)
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same sequence as `Current'?
		note
			maps_to: "Seq#Equal"
		do
			Result := attached {MML_SEQUENCE [G]} a_other as sequence and then
				(count = sequence.count and Current <= sequence)
		end

	is_less_equal alias "<=" (a_other: MML_SEQUENCE [G]): BOOLEAN
			-- If this sequence shorter than or the same length as `a_other'?
		note
			maps_to: "Seq#LessEqual"
		do
			if attached a_other as a then
                Result := count <= a.count
			end
		end

	is_prefix_of (other: MML_SEQUENCE [G]): BOOLEAN
			-- Is this sequence a prefix of `other'?
		note
			maps_to: "Seq#Prefix"
		local
			i: INTEGER
		do
			Result := count <= other.count
			from
				i := 1
			until
				i > count or Result = False
			loop
				Result := item (i) ~ other.item (i)
				i := i + 1
			end
		end

feature -- Decomposition

	first: G
			-- First element.
		require
			non_empty: not is_empty
		do
			-- check is_executable: False then end
			Result := item (1)

		ensure
			Result =  item (1)
		end

	last: G
			-- Last element.
		require
			non_empty: not is_empty
		do
			-- check is_executable: False then end
			Result := item (count)
		ensure
			Result = item (count)
		end

	but_first: MML_SEQUENCE [G]
			-- Current sequence without the first element.
		require
			not_empty: not is_empty
		do
			-- check is_executable: False then end
			Result := interval (2, count)
		end

	but_last: MML_SEQUENCE [G]
			-- Current sequence without the last element.
		require
			not_empty: not is_empty
		do
			-- check is_executable: False then end
			Result := interval (1, count - 1)
		end

	front (upper: INTEGER): MML_SEQUENCE [G]
			-- Prefix up to `upper'.
		do
		-- 	check is_executable: False then end
		    Result := interval (1, upper)
		end

--	tail (last_n: INTEGER): MML_SEQUENCE [G] -- TODO: Check it the boogie formula is correct before using this
--			-- Suffix of the last n elements
--		do
--			Result := interval (count - last_n, count)
--		end

	tail_from (lower: INTEGER): MML_SEQUENCE [G]
			-- Suffix from `lower'.
		do
			-- check is_executable: False then end
			Result := interval (lower, count)
--		ensure
--			Result = interval (lower, count)
		end

	interval (lower, upper: INTEGER): MML_SEQUENCE [G]
			-- Subsequence from `lower' to `upper'.
	local
			l, u: INTEGER
			a: ARRAY [G]
		do
			-- check is_executable: False then end
			l := lower.max (1)
			u := upper.min (count).max (l - 1)
			create a.make (1, u - l + 1)
			-- a.array_copy_range (array, l, u, 1)
            a.area.copy_data(array.area, l - array.lower, 1 - a.lower, u - l + 1)
			create Result.make_from_array (a)
		end

	removed_at (i: INTEGER): MML_SEQUENCE [G]
			-- Current sequence with element at position `i' removed.
		require
			in_domain: domain [i]
		local
			a: ARRAY [G]
		do
			-- check is_executable: False then end
			create a.make (1, array.count - 1)
			-- a.array_copy_range (array, 1, i - 1, 1)
			a.area.copy_data(array.area, 1 - array.lower, 1 - a.lower, i)

			-- a.array_copy_range (array, i + 1, array.count, i)
            a.area.copy_data(array.area, i + 1 - array.lower, i - a.lower, array.count - i)
			create Result.make_from_array (a)
		end

feature -- Modification

	extended alias "&" (x: G): MML_SEQUENCE [G]
			-- Current sequence extended with `x' at the end.
		do
			-- check is_executable: False then end
			Result := extended_at (count + 1, x)
		end

	extended_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' inserted at position `i'.
		require
			valid_position: 1 <= i and i <= count + 1
		local
			a: ARRAY [G]
		do
			-- check is_executable: False then end
			create a.make (1, array.count + 1)
			-- a.array_copy_range (array, 1, i - 1, 1)
            a.area.copy_data(array.area, 1 - array.lower,  1 - a.lower, i - 1)
			a [i] := x
			-- a.array_copy_range (array, i, array.count, i + 1)
			a.area.copy_data(array.area, i - array.lower, i + 1 - a.lower, array.count - i + 1)
			create Result.make_from_array (a)
		end

	prepended (x: G): MML_SEQUENCE [G]
			-- Current sequence prepended with `x' at the beginning.
		local
			a: ARRAY [G]
		do
			-- check is_executable: False then end
			create a.make (1, array.count + 1)
			-- a.array_copy_range (array, 1, array.count, 2)
            a.area.copy_data(array.area, 1 - array.lower, 2 - a.lower, array.count)
			a [1] := x
			create Result.make_from_array (a)
		end

	concatenation alias "+" (other: MML_SEQUENCE [G]): MML_SEQUENCE [G]
			-- The concatenation of the current sequence and `other'.
		note
			maps_to: "Seq#Concat"
		local
			a: ARRAY [G]
		do
			if is_empty then
				Result := other
			elseif other.is_empty then
				Result := Current
			else
				create a.make (1, count + other.count)
				-- a.array_copy_range (array, 1, array.count, 1)
				a.area.copy_data(array.area, 1- array.lower, 1 - a.lower, array.count)

				-- a.array_copy_range (other.array, 1, other.array.count, count + 1)
				a.area.copy_data(other.array.area, 1 - other.array.lower, array.count + 1 - a.lower, other.array.count)
				create Result.make_from_array (a)
			end
			-- check is_executable: False then end
		end

	replaced_at (i: INTEGER; x: G): MML_SEQUENCE [G]
			-- Current sequence with `x' at position `i'.
		note
			maps_to: "Seq#Update"
		require
			-- in_domain: domain [i]
			-- Li *
			in_domain: 1 <= i and i <= count
		    -- *
		local
			a: ARRAY [G]
		do
			a := array.twin
			a [i] := x
			create Result.make_from_array (a)
			-- check is_executable: False then end
		end

feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		note
			maps_to: "Seq#Range"
		do
			check is_executable: False then end
		end

feature -- Convenience

	empty_sequence: MML_SEQUENCE [G]
			-- Empty sequence.
			-- Can be used as `{MML_SEQUENCE [G]}.empty_sequence'.
		note
			maps_to: "Seq#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

	non_void: BOOLEAN
			-- Does this sequence contain only non-Void elements?
		note
			maps_to: "Seq#NonNull"
		local
			i: INTEGER
		do
			if attached array as arr then
			from
				i := 1
			    Result := True
			until
				i > count or Result = False
			loop
			   Result := arr [i] /= Void
               i := i + 1
			end
			end
		end

	no_duplicates: BOOLEAN
		do
		end

feature -- {MML_SEQUENCE}

	array: ARRAY [G]
			-- Element storage.

	make_from_array (a: ARRAY [G])
			-- Create with a predefined array.
		require
			starts_from_one: a.lower = 1
		do
			array := a
		end

feature -- Lemmas

	lemma_no_duplicates
			-- In a sequence with no duplicates, each element occurs exactly once.
		note
			status: lemma
		do
			if not is_empty then
				but_last.lemma_no_duplicates
				check Current = but_last & last end
				check (∀ i: 1 |..| (count - 1) ¦ item (i) /= last) implies but_last.to_bag [last] = 0 end
				check but_last.to_bag [last] = 0 implies ∀ i: 1 |..| (count - 1) ¦ item (i) /= last end
			end
		ensure
			no_duplicates = to_bag.is_constant (1)
		end

end
