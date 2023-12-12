note
	description: "Summary description for {P_INTERNAL}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	P_INTERNAL

inherit
	INTERNAL

feature

	set_integer_32_field_ (name: READABLE_STRING_GENERAL; object: ANY; value: INTEGER_32)
			-- Set integer value of an object field
		local
			i: INTEGER
		do
			from
				i := 1
			until
				field_name (i, object).same_string_general (name) or else i > field_count (object)
			loop
				i := i + 1
			end

			if i <= field_count (object) then
				set_integer_32_field (i, object, value)
			end
		ensure
			instance_free: class
		end

	set_integer_field_ (name: READABLE_STRING_GENERAL; object: ANY; value: INTEGER)
			-- Set integer value of an object field
		local
			i: INTEGER
		do
			from
				i := 1
			until
				field_name (i, object).same_string_general (name) or else i > field_count (object)
			loop
				i := i + 1
			end

			if i <= field_count (object) then
				set_integer_field (i, object, value)
			end
		ensure
			instance_free: class
		end

	set_boolean_field_ (name: READABLE_STRING_GENERAL; object: ANY; value: BOOLEAN)
			-- Set boolean value of an object field
		local
			i: INTEGER
		do
			from
				i := 1
			until
				field_name (i, object).same_string_general (name) or else i > field_count (object)
			loop
				i := i + 1
			end

			if i <= field_count (object) then
				set_boolean_field (i, object, value)
			end
		ensure
			instance_free: class
		end

	set_reference_field_ (name: READABLE_STRING_GENERAL; object: ANY; object_value: ANY)
			-- Set value of an object field of reference type
		local
			i: INTEGER
		do
			from
				i := 1
			until
				field_name (i, object).same_string_general (name) or else i > field_count (object)
			loop
				i := i + 1
			end

			if i <= field_count (object) then
				set_reference_field (i, object, object_value)
			end
		ensure
			instance_free: class
		end

	set_natural_64_field_ (name: READABLE_STRING_GENERAL; object: ANY; value: NATURAL_64)
			-- Set value of an object field of natural_64 type
		local
			i: INTEGER
		do
			from
				i := 1
			until
				field_name (i, object).same_string_general (name) or else i > field_count (object)
			loop
				i := i + 1
			end
			if i <= field_count (object) then
				set_natural_64_field (i, object, value)
			end

		ensure
			instance_free: class
		end

end
