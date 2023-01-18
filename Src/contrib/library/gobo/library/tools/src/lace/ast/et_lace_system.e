note

	description:

		"Lace Eiffel systems"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001-2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

class ET_LACE_SYSTEM

obsolete

	"Use ET_ECF_* classes instead. [2019-03-17]"

inherit

	ET_SYSTEM
		redefine
			clusters
		end

create

	make

feature -- Access

	clusters: ET_LACE_CLUSTERS
			-- Clusters

end
