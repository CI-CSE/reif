note
	description: "Summary description for {FB_SUMMARY}."
	author: ""
	date: "$Date: 2018-09-07 00:07:18 +0800 (周五, 07 9月 2018) $"
	revision: "$Revision: 102137 $"

class
	FB_SUMMARY

feature -- Access

	total_count: INTEGER
		-- Total number of objects on this edge.
feature -- Element Change

	set_total_count (a_count: INTEGER)
			-- Set `total_count' with `a_count'.
		do
			total_count := a_count
		ensure
			total_count_set: total_count = a_count
		end

feature  -- Status Report

	shout_out: STRING
		do
			create Result.make_from_string ("SUMMARY")
			Result.append (" %N total count:")
			Result.append_integer (total_count)
			Result.append ("%N")
		end
end
