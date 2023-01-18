note
	description: "Summary description for {IMAGE_DATA}."
	date: "$Date: 2012-05-03 17:27:12 +0800 (周四, 03 5月 2012) $"
	revision: "$Revision: 88682 $"

class
	IMAGE_DATA

create
	make

feature {NONE} -- Initialization

	make
			-- Init
		do
			create my_image.make_empty
		end

feature -- Access

	id: INTEGER
			-- ID of the image

	my_image: STRING
			-- Binarary data of the image

end
