note

	description:

		"Windows-like file systems which only accept backslash as directory separator."

	library: "Gobo Eiffel Kernel Library"
	copyright: "Copyright (c) 2018, Eric Bezault and others"
	license: "MIT License"
	date: "$Date: 2019-02-08 06:54:15 +0800 (周五, 08 2月 2019) $"
	revision: "$Revision: 102807 $"

class KL_WINDOWS_FILE_SYSTEM_BACKSLASH_ONLY

inherit

	KL_WINDOWS_FILE_SYSTEM
		redefine
			secondary_directory_separator
		end

create

	make

feature -- Pathname handling

	secondary_directory_separator: CHARACTER
			-- Secondary directory separator
		once
			Result := '\'
		end

end
