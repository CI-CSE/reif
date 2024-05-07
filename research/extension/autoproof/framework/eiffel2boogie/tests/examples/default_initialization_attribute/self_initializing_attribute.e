note
	description:"[
		Test that integer, real, boolean, detachable attributes are automatically initialized to their respective default value.
	]"
class SELF_INITIALIZING_ATTRIBUTE

create make

feature
	integer_attribute: INTEGER
	real_attribute: REAL
	boolean_attribute: BOOLEAN
	detachable_attribute: detachable ANY

	make
		-- Creator which relies on the automatic initialization of attributes
		note
			status: creator
		do
		ensure
			correct_integer_self_initialization: integer_attribute = 0
			correct_real_self_initialization: real_attribute = 0.0
			correct_boolean_self_initialization: boolean_attribute = False
			correct_detachable_self_initialization: detachable_attribute = Void
		end

end
