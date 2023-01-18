note
	description: "Class to write snippets into a medium in a binary serialized format."
	date: "$Date: 2011-07-21 22:08:03 +0800 (Thu, 21 Jul 2011) $"
	revision: "$Revision: 86884 $"

class
	EXT_BINARY_SNIPPET_WRITER

inherit
	EXT_SNIPPET_WRITER

feature -- Basic operations

	write (a_snippet: EXT_SNIPPET; a_medium: IO_MEDIUM)
			-- Write `a_snippet' into `a_medium'.
		do
			a_snippet.clear_internal
			a_snippet.independent_store (a_medium)
		end

	write_to_file (a_snippet: EXT_SNIPPET; a_path: STRING)
			-- Write each of `a_snippets' to a file whose absolute path is given by `a_path'.
		do
			a_snippet.clear_internal
			a_snippet.store_by_name (a_path)
		end

end
