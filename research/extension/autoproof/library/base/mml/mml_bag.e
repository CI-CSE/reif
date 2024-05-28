note
	description: "Finite bags."
	author: "Nadia Polikarpova"
	revised_by: "Alexander Kogtenkov"
	theory: "bag.bpl", "set.bpl"
	maps_to: "Bag"
	where: "Bag#IsValid"
	type_properties: "Bag#DomainType"

class
	MML_BAG [G]

inherit
	ITERABLE [G]
		redefine
			default_create,
			is_equal
		end

create
	default_create,
	singleton,
	multiple,
	make_from_arrays

feature {NONE} -- Initialization

	default_create
			-- Create an empty bag.
		note
			maps_to: "Bag#Empty"
		do
			create keys.make (1, 0)
			create values.make (1, 0)
		end

	singleton (x: G)
			-- Create a bag that contains a single occurrence of `x'.
		do
			multiple (x, 1)
		end

	multiple (x: G; n: INTEGER)
			-- Create a bag that contains `n' occurrences of `x'.
		require
			n_positive: n >= 0
		do
			if n = 0 then
				default_create
			else
				create keys.make (1, 1)
				keys [1] := x
				create values.make (1, 1)
				values [1] := n
				-- TODO Li* count := n
			end
		end

	make_from_arrays (ks: ARRAY [G]; vs: ARRAY [INTEGER]; n: INTEGER)
			-- Create with predefined arrays and count.
	 	require
			ks_exists: ks /= Void
			vs_exists: vs /= Void
			same_lower: ks.lower = vs.lower
			same_upper: ks.upper = vs.upper
			start_at_one: ks.lower = 1
			-- ks_has_no_duplicates: ks.to_mml_bag.is_constant (1)
			-- TODO Li* -- vs_positive: vs.for_all (agent (x: INTEGER): BOOLEAN do Result := x > 0 end)
			--- n_valid: n = sum i: INTEGER :: vs.lower <= i and i <= vs.upper ==> vs [i]
		do
			create keys.make_from_array (ks)
			create values.make_from_array (vs)
			-- TODO Li* count := n
		end

feature -- Properties

	has (x: G): BOOLEAN
			-- Is `x' contained?
		do
			Result := occurrences (x) > 0
		end

	is_empty: BOOLEAN
			-- Is bag empty?
		do
			Result := keys.is_empty
		end

	is_constant (c: INTEGER): BOOLEAN
			-- Are all values equal to `c'?
		do
			-- TODO Li* -- Result := values.for_all (agent reference_equal (c, ?))
		end

	is_valid: BOOLEAN
			-- Id `Current' a valid bag (are all occurrences non-negative)?
		do
			-- TODO
		end

feature -- Sets

	domain: MML_SET [G]
			-- Set of values that occur at least once.
		do
			check is_executable: False then end
		end

feature -- Measurement

	occurrences alias "[]" (x: G): INTEGER
			-- How many times `v' appears.
		note
			maps_to: "[]"
		local
			i: INTEGER
		do
			i := first_key_index (x) -- keys.index_satisfying (agent meq (x, ?))
			if i /= 0 then
				Result := values [i]
			end
		end

	count alias "#": INTEGER
			-- Total number of elements.
		note
			maps_to: "Bag#Card"
		 do
		 end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same bag as `Current'?
		note
			maps_to: "Bag#Equal"
		local
			i: INTEGER
		do
			if attached {MML_BAG [G]} a_other as bag and then count = bag.count then
				from
					Result := True
					i := 1
				until
					i > keys.count or not Result
				loop
					Result := bag [keys [i]] = values [i]
					i := i + 1
				end
			end
		end

	is_subbag alias "<=" (a_other: MML_BAG [G]): BOOLEAN
			-- Does `other' contain all the elements of `Current'?
		note
			maps_to: "Bag#Subset"
		do
		end

	is_disjoint (a_other: MML_BAG [G]): BOOLEAN
			-- Do `a_other' and `Current' have no elements in common?
		note
			maps_to: "Bag#Disjoint"
		do
		end

feature -- Modification

	extended alias "&" (x: G): MML_BAG [G]
			-- Current bag extended with one occurrence of `x'.
		do
			-- check is_executable: False then end
			Result := extended_multiple (x, 1)
		end

	extended_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag extended with `n' occurrences of `x'.
		require
			n_non_negative: n >= 0
		local
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
			i: INTEGER
		do
			-- check is_executable: False then end
			if n > 0 then
				i := first_key_index (x)
				if i /= 0 then
					ks := keys
					vs := values.twin
					vs [i] := vs [i] + n
				else
					create ks.make (1, keys.count + 1)
					ks.subcopy (keys, 1, keys.count, 1)
					ks [ks.count] := x
					create vs.make (1, values.count + 1)
					vs [vs.count] := n
					vs.subcopy (values, 1, values.count, 1)
				end
				create Result.make_from_arrays (ks, vs, count + n)
			else
				Result := Current
			end
		end

	removed alias "/" (x: G): MML_BAG [G]
			-- Current bag with one occurrence of `x' removed if present.
		do
			-- check is_executable: False then end
			Result := removed_multiple (x, 1)
		end

	removed_multiple (x: G; n: INTEGER): MML_BAG [G]
			-- Current bag with at most `n' occurrences of `x' removed if present.
		require
			n_non_negative: n >= 0
		local
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
			i: INTEGER
		do
		-- 	check is_executable: False then end
			i := first_key_index (x) -- keys.index_satisfying (agent meq (x, ?))
			if n = 0 or i = 0 then
				Result := Current
			elseif values [i] <= n then
				create ks.make (1, keys.count - 1)
				ks.subcopy (keys, 1, i - 1, 1)
				ks.subcopy (keys, i + 1, keys.count, i)
				create vs.make (1, values.count - 1)
				vs.subcopy (values, 1, i - 1, 1)
				vs.subcopy (values, i + 1, values.count, i)
				create Result.make_from_arrays (ks, vs, count - n)
			else
				vs := values.twin
				vs [i] := vs [i] - n
				create Result.make_from_arrays (keys, vs, count - n)
			end
		end

	removed_all (x: G): MML_BAG [G]
			-- Current bag with all occurrences of `x' removed.
		do
			-- check is_executable: False then end
			Result := removed_multiple (x, occurrences (x))
		end

	restricted alias "|" (subdomain: MML_SET [G]): MML_BAG [G]
			-- Bag that consists of all elements of `Current' that are in `subdomain'.
		local
			i, j: INTEGER
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
			n: INTEGER
		do
			-- check is_executable: False then end
			create ks.make (1, keys.count)
			create vs.make (1, values.count)
			from
				i := 1
				j := 1
			until
				i > keys.count
			loop
				if subdomain [keys [i]] then
					ks [j] := keys [i]
					vs [j] := values [i]
					n := n + values [i]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (1, j - 1)
			vs.resize (1, j - 1)
			create Result.make_from_arrays (ks, vs, n)
		end

    first_key_index (k: G): INTEGER
    local
       i: INTEGER
    do
        from
			i := 1  -- index starts from 1
		until
			keys [i] ~ k or i > keys.count
		loop
			i := i + 1
		end

		if i <= keys.count then
		   Result := i
		end
    end

	union alias "+" (other: MML_BAG [G]): MML_BAG [G]
			-- Bag that contains all elements from `other' and `Current'.
		local
			i, j, k: INTEGER
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
		do
			create ks.make (1, keys.count + other.keys.count)
			create vs.make (1, values.count + other.values.count)
			ks.subcopy (keys, 1, keys.count, 1)
			vs.subcopy (values, 1, values.count, 1)
			from
				i := 1
				j := keys.count + 1
			until
				i > other.keys.count
			loop
				k := first_key_index (other.keys [i])-- keys.index_satisfying (agent meq (other.keys [i], ?))
				if i /= 0 then
					vs [k] := vs [k] + other.values [i]
				else
					ks [j] := other.keys [i]
					vs [j] := other.values [i]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (1, j - 1)
			vs.resize (1, j - 1)
			create Result.make_from_arrays (ks, vs, count + other.count)
		end

	intersection alias "*" (other: MML_BAG [G]): MML_BAG [G]
			-- Bag that contains only elements present in both `other' and `Current'.
		do
			check is_executable: False then end
		end

	difference alias "-" (other: MML_BAG [G]): MML_BAG [G]
			-- Current bag with all occurrences of values from `other' removed.
		local
			i, j, k, c: INTEGER
			ks: ARRAY [G]
			vs: ARRAY [INTEGER]
		do
			create ks.make (1, keys.count)
			create vs.make (1, values.count)
			from
				i := 1
				j := 1
			until
				i > keys.count
			loop
				k := other [keys [i]]
				if k < values [i] then
					ks [j] := keys [i]
					vs [j] := values [i] - k
					c := c + vs [j]
					j := j + 1
				end
				i := i + 1
			end
			ks.resize (1, j - 1)
			vs.resize (1, j - 1)
			create Result.make_from_arrays (ks, vs, c)
		end

feature -- Iterable implementation

	keys: ARRAY [G]
			-- Element storage.

	values: ARRAY [INTEGER]
			-- Occurrences storage.

	meq (v1, v2: G): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			-- TODO Li* Result := model_equals (v1, v2)
		end

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		note
			maps_to: "Bag#Domain"
		do
			check is_executable: False then end
		end

feature -- Convenience

	empty_bag: MML_BAG [G]
			-- Empty bag.
			-- Can be used as `{MML_BAG [G]}.empty_bag'.
		note
			maps_to: "Bag#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

feature -- Lemmas

	lemma_remove_multiple (v: G; n: INTEGER)
			-- Removing `n' occurrences of `v' from `Current' and then one,
			-- is the same as removing `n' + 1 occurrences.
		note
			status: lemma
		require
			n >= 0
		do
			check ∀ x: domain ¦ removed_multiple (v, n).removed (v) [x] = removed_multiple (v, n + 1) [x] end
		ensure
			removed_multiple (v, n).removed (v) = removed_multiple (v, n + 1)
		end

	lemma_remove_all (v: G)
			-- Removing `Current [v]' occurrences of `v' from `b' is the same as removing all occurrences.
		note
			status: lemma
		do
			check ∀ x: domain ¦ removed_multiple (v, Current [v]) [x] = removed_all (v) [x] end
		ensure
			removed_multiple (v, Current [v]) = removed_all (v)
		end

	lemma_domain_count
			-- `domain' has no more elements thatn the bag,
			-- and they have equal number of elements iff every element occurs exactly once.
		note
			status: lemma
		local
			x: G
		do
			if not is_empty then
				x := domain.any_item
				check Current = (Current / x) & x end
				check domain = (Current / x).domain & x end
				check Current [x] = (Current / x) [x] + 1 end
				check is_constant (1) implies not (Current / x).domain [x] end
				check domain.count = if Current [x] = 1 then (Current / x).domain.count + 1 else (Current / x).domain.count end end
				(Current / x).lemma_domain_count
			end
		ensure
			(count = domain.count) = is_constant (1)
			domain.count <= count
		end

invariant
	same_lower: keys.lower = values.lower
	same_upper: keys.upper = values.upper
	start_at_one: keys.lower = 1
end
