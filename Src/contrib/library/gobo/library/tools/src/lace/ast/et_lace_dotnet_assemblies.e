note

	description:

		".NET assembly lists read from Ace file"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2006-2019, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

class ET_LACE_DOTNET_ASSEMBLIES

obsolete

	"Use ET_ECF_* classes instead. [2019-03-17]"

inherit

	ET_DOTNET_ASSEMBLIES
		redefine
			dotnet_assembly
		end

create

	make, make_empty

feature -- Access

	dotnet_assembly (i: INTEGER): ET_LACE_DOTNET_ASSEMBLY
			-- `i'-th assembly
		do
			Result := dotnet_assemblies.item (i)
		end

end
