note
	description: "Summary description for {EPA_STRING_VALUE}."
	author: ""
	date: "$Date: 2011-12-12 05:07:14 +0800 (Mon, 12 Dec 2011) $"
	revision: "$Revision: 88109 $"

class
	EPA_STRING_VALUE

inherit
	EPA_ANY_VALUE
		rename
			make as old_make
		redefine
			text, out,
			as_string,
			is_string,
			process
		end

create
	make

feature{NONE} -- Initialization

	make (a_address: STRING; a_str: STRING)
		-- Initialize Current.
		do
			old_make (a_address)
			string_value := a_str.twin
		end

feature -- Access

	string_value: STRING
			-- String value

	text, out: STRING
			-- New string containing terse printable representation
			-- of current object
		do
			Result := string_value
		end

	as_string: detachable EPA_STRING_VALUE
			-- Current as string value
		do
			Result := Current
		end

feature -- Status report

	is_string: BOOLEAN = True
			-- Is current a string value?	

feature -- Process

	process (a_visitor: EPA_EXPRESSION_VALUE_VISITOR)
			-- Process Current using `a_visitor'.
		do
			a_visitor.process_string_value (Current)
		end

end
