note
	description: "Summary description for {CMS_STORAGE_STORE_MYSQL}."
	date: "$Date: 2015-06-18 20:26:23 +0800 (周四, 18 6月 2015) $"
	revision: "$Revision: 97484 $"

class
	CMS_STORAGE_STORE_MYSQL

inherit
	CMS_STORAGE_STORE_SQL

	CMS_CORE_STORAGE_SQL_I

	CMS_USER_STORAGE_SQL_I

	REFACTORING_HELPER

create
	make

feature -- Status report

	is_initialized: BOOLEAN
			-- Is storage initialized?
		do
			Result := has_user
		end

feature -- Conversion

	sql_statement (a_statement: STRING): STRING
			-- <Precursor>
		do
			Result := a_statement
		end

end
