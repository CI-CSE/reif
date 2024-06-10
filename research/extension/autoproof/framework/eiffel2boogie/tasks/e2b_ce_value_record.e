note
	description: "Record represented in a counterexample"

class
	E2B_CE_VALUE_RECORD

inherit
	E2B_CE_VALUE

create
	make, make_empty, make_copy

feature {NONE}
	make (a_values: HASH_TABLE [STRING, STRING])
		do
			create values.make (a_values.count)
			values.copy (a_values)
		end

	make_empty
		do
			create values.make (0)
		end

	make_copy (other: E2B_CE_VALUE_RECORD)
		do
			create values.make (other.values.count)
			values.copy (other.values)
		end

feature

	values: HASH_TABLE [STRING, STRING]

	copied: E2B_CE_VALUE_RECORD
		do
			create Result.make_copy (Current)
		end

	put (v, k: STRING)
		do
			values [k] := v
		end
end
