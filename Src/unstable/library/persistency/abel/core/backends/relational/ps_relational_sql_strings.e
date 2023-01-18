note
	description: "Summary description for {PS_RELATIONAL_SQL_STRINGS}."
	author: ""
	date: "$Date: 2014-01-14 07:58:56 +0800 (周二, 14 1月 2014) $"
	revision: "$Revision: 93974 $"

deferred class
	PS_RELATIONAL_SQL_STRINGS

feature

	show_tables: STRING
		deferred
		end

	assemble_upsert (table: READABLE_STRING_8; columns: LIST [STRING]; values: LIST [STRING]): STRING
		deferred
		end
end
