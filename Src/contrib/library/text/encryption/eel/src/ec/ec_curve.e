note
	description: "Objects that ..."
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-12 01:13:16 +0800 (周六, 12 11月 2011) $"
	revision: "$Revision: 87787 $"
	quote: "None are more hopelessly enslaved than those who falsely believe they are free. - Goethe"

deferred class
	EC_CURVE

inherit
	DEBUG_OUTPUT

feature
	a: EC_FIELD_ELEMENT
	b: EC_FIELD_ELEMENT

feature {DEBUG_OUTPUT} -- {DEBUG_OUTPUT}
	debug_output: STRING
		do
			result := "a: " + a.debug_output + "%Nb: " + b.debug_output
		end
end
