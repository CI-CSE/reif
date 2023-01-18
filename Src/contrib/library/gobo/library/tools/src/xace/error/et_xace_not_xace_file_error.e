note

	description:

		"Error: Input is not an Xace file"

	library: "Gobo Eiffel Tools Library"
	copyright: "Copyright (c) 2001-2019, Andreas Leitner and others"
	license: "MIT License"
	date: "$Date: 2019-07-30 00:31:53 +0800 (周二, 30 7月 2019) $"
	revision: "$Revision: 103358 $"

class ET_XACE_NOT_XACE_FILE_ERROR

obsolete

	"Use ET_ECF_* classes instead. [2019-03-17]"

inherit

	ET_XACE_ERROR

create

	make

feature {NONE} -- Initialization

	make (a_filename: STRING)
			-- Create a new error reporting that file `a_filename'
			-- does not contain an Xace document.
		require
			a_filename_not_void: a_filename /= Void
		do
			create parameters.make_filled (empty_string, 1, 1)
			parameters.put (a_filename, 1)
		end

feature -- Access

	default_template: STRING = "'$1' is not an Xace file"
			-- Default template used to built the error message

	code: STRING = "XA0007"
			-- Error code

invariant

	-- dollar1: $1 = a_filename

end
