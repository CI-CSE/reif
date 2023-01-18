note
	description: "An object that is DER encodable"
	author: "Colin LeMahieu"
	date: "$Date: 2011-11-12 01:13:16 +0800 (周六, 12 11月 2011) $"
	revision: "$Revision: 87787 $"
	quote: "I think the terror most people are concerned with is the IRS. - Malcolm Forbes, when asked if he was afraid of terrorism"

deferred class
	DER_ENCODABLE

inherit
	DER_FACILITIES

feature
	der_encode (target: DER_OCTET_SINK)
		deferred
		end
end
