note
	description: "DER octet source"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-12 01:13:16 +0800 (周六, 12 11月 2011) $"
	revision: "$Revision: 87787 $"
	quote: "Our forefathers made one mistake. What they should have fought for was representation without taxation. - Fletcher Knebel, historian"

deferred class
	DER_OCTET_SOURCE

feature
	has_item: BOOLEAN
		deferred
		end

	item: NATURAL_8
		require
			has_item
		deferred
		end

	process
		require
			has_item
		deferred
		end
end
