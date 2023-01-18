note
	description: "Summary description for {LIMB_DEFINITION}."
	author: ""
	date: "$Date: 2011-11-12 01:13:16 +0800 (周六, 12 11月 2011) $"
	revision: "$Revision: 87787 $"

deferred class
	LIMB_DEFINITION

feature

	limb_high_bit: INTEGER = 31
			-- Index of the high bit of a limb

	limb_bits: INTEGER = 32
			-- Number of bits in a limb
end
