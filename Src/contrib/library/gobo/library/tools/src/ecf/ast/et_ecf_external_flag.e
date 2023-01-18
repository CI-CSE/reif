note

	description:

		"ECF flags to be passed for external compilations"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2017, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

deferred class ET_ECF_EXTERNAL_FLAG

inherit

	ET_ECF_EXTERNAL_VALUE
		rename
			value as flag
		end

end
