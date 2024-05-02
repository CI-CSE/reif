note
	description: "Finite sets."
	author: "Nadia Polikarpova"
	revised_by: "Alexander Kogtenkov"
	theory: "set.bpl"
	maps_to: "Set"
	type_properties: "Set#ItemsType"

class MML_SET [G -> detachable separate ANY]

inherit
		-- Li: a set must be iterable
	ITERABLE [G]
		redefine
			default_create,
			is_equal,
			out
		end

create
	default_create,
	singleton,
	make_from_array

feature {NONE} -- Initialization

	default_create
			-- Create an empty set.
		note
			maps_to: "Set#Empty"
		do
			create array.make_empty
			array.compare_objects
		end

	singleton (x: G)
			-- Create a set that contains only `x'.
		do
			create array.make_filled (x, 1, 1)
			array.compare_objects
		end

feature -- io
	out: STRING
		do
			Result := "{"
			⟳ i: 1 |..| array.count ¦
				if attached {ANY} array [i] as att_i then
					Result := Result + att_i.out + ", "
				else
					Result := Result + "NA, "
				end
			⟲
			if array.count > 0 then
				Result.remove_tail (2)
			end
			Result := Result + "}"
		end

feature -- Properties

	has alias "[]" (x: G): BOOLEAN
			-- Is `x' contained?
		note
			maps_to: "[]"
		do
			Result := array.has (x)
		end

	is_empty alias "∅=": BOOLEAN
			-- Is the set empty?
		do
			Result := array.is_empty
		end

feature -- Elements

	any_item: G
			-- Arbitrary element.
		require
			not_empty: not is_empty
		do
				-- check is_executable: False then end
			Result := array [1]
		ensure
			element: has (Result)
		end

--	min: G
--			-- Least element.
--		require
--			not_empty: not is_empty
--		do
--			check is_executable: False then end
--		end

--	max: G
--			-- Greatest element.
--		require
--			not_empty: not is_empty
--		do
--			check is_executable: False then end
--		end

feature -- Measurement

	count alias "#": INTEGER
			-- Cardinality.
		note
			maps_to: "Set#Card"
		do
			Result := array.count
		end

feature -- Comparison

	is_equal (a_other: like Current): BOOLEAN
			-- Is `a_other' the same set as `Current'?
		note
			maps_to: "Set#Equal"
		do
			Result := attached {MML_SET [G]} a_other as set and then
				(count = set.count and Current <= set)
		end

	is_subset_of alias "<=" alias "⊆" (a_other: MML_SET [G]): BOOLEAN
			-- Does `a_other' have all elements of `Current'?
		note
			maps_to: "Set#Subset"
		local
			i: INTEGER
		do
			if attached {MML_SET [G]} a_other as set and then count <= set.count then
				from
					i := 1
					Result := True
				until
					i > array.count or Result = False
				loop
					Result := set.array.has (array [i])
					i := i + 1
				end
			end
		end

	is_superset_of alias ">=" alias "⊇" (a_other: MML_SET [G]): BOOLEAN
			-- Does `Current' have all elements of `a_other'?
		note
			maps_to: "Set#Superset"
		do
			Result := a_other <= Current
		end

	is_disjoint (a_other: MML_SET [G]): BOOLEAN
			-- Do no elements of `a_other' occur in `Current'?
		note
			maps_to: "Set#Disjoint"
		local
			i: INTEGER
		do
			Result := True
			if attached a_other as set then
				from
					i := 1
				until
					i > array.count or Result = False
				loop
					Result := not set.has (array [i])
					i := i + 1
				end
			end
		end

feature -- Modification

	extended alias "&" (x: G): MML_SET [G]
			-- Current set extended with `x' if absent.
		local
			a: ARRAY [G]
		do
				-- check is_executable: False then end
			if not Current [x] then
				create a.make_empty
				a.grow (array.count + 1)
					-- a.array_copy_range (array, 1, array.count, 1)
				a.area.copy_data (array.area, 1 - array.lower, 1 - a.lower, array.count)
				a [a.count] := x
				create Result.make_from_array (a)
			else
				Result := Current
			end
		end

	removed alias "/" (x: G): MML_SET [G]
			-- Current set with `x' removed if present.
		local
			a: ARRAY [G]
			i: INTEGER
		do
				-- check is_executable: False then end
			i := array.area.index_of (x, 1)
			if array.lower <= i and i <= array.upper then
				create a.make_empty
				a.grow (array.count - 1)
					-- a.array_copy_range (array, 1, i - 1, a.lower)
				a.area.copy_data (array.area, 1 - array.lower, 0, i - 1)

					-- a.array_copy_range (array, i + 1, array.count, i)
				a.area.copy_data (array.area, i + 1 - array.lower, i - a.lower, array.count - i)
				create Result.make_from_array (a)
			else
				Result := Current
			end
		end

	union alias "+" alias "∪" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other'.
		do
				-- check is_executable: False then end
			Result := Current - other

			if Result.array.count + other.array.count > 0 then
				Result.array.resize (1, Result.array.count + other.array.count)
					-- Result.array.array_copy_range (other.array, 1, other.array.count, Result.array.count - other.count + 1)
				Result.array.area.copy_data (other.array.area, 1 - other.array.lower, Result.array.count - other.count + 1 - Result.array.lower, other.array.count)
			end

		ensure
			contains_current: Current <= Result
			contains_other: other <= Result
		end

	intersection alias "*" alias "∩" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in both `Current' and `other'.
		local
			a: ARRAY [G]
			i, j: INTEGER
		do
				-- check is_executable: False then end
			create a.make_empty
			a.grow (array.count)
			from
				i := 1
				j := 1
			until
				i > array.count
			loop
				if other [array [i]] then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			a.keep_head (j - 1)
			create Result.make_from_array (a)
		ensure
			contained_in_current: Result <= Current
			contained_in_other: Result <= other
		end

	difference alias "-" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in `Current' but not in `other'.
		local
			a: ARRAY [G]
			i, j: INTEGER
		do
				-- check is_executable: False then end
			create a.make_empty
			a.grow (array.count)
			from
				i := 1
				j := 1
			until
				i > array.count
			loop
				if not other [array [i]] then
					a [j] := array [i]
					j := j + 1
				end
				i := i + 1
			end
			a.keep_head (j - 1)
			create Result.make_from_array (a)
		ensure
			contained_in_current: Result <= Current
			disjoint_from_other: Result.IS_disjoint (other)
		end

	sym_difference alias "^" (other: MML_SET [G]): MML_SET [G]
			-- Set of values contained in either `Current' or `other', but not in both.
		do
				-- check is_executable: False then end
			Result := (Current + other) - (Current * other)
		ensure
			definition: Result.is_equal ((Current + other) - (Current * other))
		end

feature -- Iterable implementation

	new_cursor: ITERATION_CURSOR [G]
			-- <Precursor>
		note
			maps_to: ""
		do
			Result := array.new_cursor
				-- Li: the target of creation call cannot be a deffered type
				-- Result := create {ITERATION_CURSOR [ANY]}.default_create
		end

feature -- Convenience

	empty_set: MML_SET [G]
			-- Empty set.
			-- Can be used as `{MML_SET [G]}.empty_set'.
		note
			maps_to: "Set#Empty"
		external "C inline"
		alias
			"[
				return NULL;
			]"
		end

	non_void: BOOLEAN
			-- Are all elements non-Void?
		note
			maps_to: "Set#NonNull"
		do
		end

feature {MML_SET} -- Implementation

	array: ARRAY [G]
			-- Element storage.

	meq (v1, v2: ANY): BOOLEAN
			-- Are `v1' and `v2' mathematically equal?
			-- The same as `model_equals' but with generic arguments.
			-- Workaround for agent typing problem.
		do
			Result := model_equals (v1, v2)
		end

feature
	make_from_array (a: ARRAY [G])
			-- Create with a predefined array.
		require
			starts_from_one: a.lower = 1
			-- no_duplicates: a.bag.is_constant (1)
			-- no_duplicates: across a as ai all a.occurrences (ai) = 1 end
		local
			distinct, pointer: INTEGER
		do
			array := a.twin
				-- inplace remove duplicates
			if array.count > 1 then
				from
					distinct := 1 -- distinct values in array
					pointer := array.lower + 1 -- pointer to search through array
				until
					pointer > array.upper
				loop
						-- if value at pointer is new → add it and increase the number of distinct values
					if ¬ array.subarray (array.lower, array.lower + distinct - 1).has (array [pointer]) then
						array [array.lower + distinct] := array [pointer]
						distinct := distinct + 1
					end
					pointer := pointer + 1
				end
				array := array.subarray (array.lower, array.lower + distinct - 1) -- cut of tail of repeating values
			end
			array.compare_objects
		end

	to_array: ARRAY [G]
		do
			create Result.make_empty
			Result.deep_copy (array)
		end

feature -- Lemmas

	lemma_subset (other: like Current)
			-- A subset with no less elements is the same set.
		note
			status: lemma
		require
			subset: other <= Current
			count: count <= other.count
		local
			x: G
		do
			if not other.is_empty then
				x := other.any_item
				removed (x).lemma_subset (other / x)
				check Current = removed (x) & x end
			end
		ensure
			Current = other
		end

invariant
	always_compare_objects_not_references: array.object_comparison

end
