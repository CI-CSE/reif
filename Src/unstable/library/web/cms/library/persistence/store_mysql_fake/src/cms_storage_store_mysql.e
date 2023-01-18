note
	description: "Summary description for {CMS_STORAGE_STORE_MYSQL}."
	date: "$Date: 2017-09-07 04:42:15 +0800 (周四, 07 9月 2017) $"
	revision: "$Revision: 100740 $"

class
	CMS_STORAGE_STORE_MYSQL

inherit
	CMS_STORAGE_NULL

create
	make

feature

	make
		do
			default_create
		end

end -- class CMS_STORAGE_STORE_MYSQL
