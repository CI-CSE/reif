note
	description: "Summary description for {HMAC_MD5}."
	author: ""
	date: "$Date: 2013-08-23 22:06:19 +0800 (周五, 23 8月 2013) $"
	revision: "$Revision: 92891 $"

class
	HMAC_MD5

inherit
	HMAC [MD5_HASH]

create
	make,
	make_ascii_key

feature {NONE} -- Implementation

	new_message_hash: like message_hash
			-- New message hash object.
		do
			create Result.make
		end

end -- class HMAC_MD5
