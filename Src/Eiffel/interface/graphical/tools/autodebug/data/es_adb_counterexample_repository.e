note
	description: "Summary description for {ES_ADB_TEST_CASE_REPOSITORY}."
	author: ""
	date: "$Date: 2014-06-22 06:38:32 +0800 (Sun, 22 Jun 2014) $"
	revision: "$Revision: 95320 $"

class
	ES_ADB_COUNTEREXAMPLE_REPOSITORY

inherit
	EPA_UTILITY

feature -- Test cases: Access

	counterexamples: DS_ARRAYED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]
		do
			Result := counterexamples_storage.item
		end

feature -- Test cases: Access

	register_counterexample (a_ce: E2B_INITIAL_STATE_OF_ROUTINE)
			-- Register `a_test' with Current.
		require
			a_ce /= Void
		local
			l_feature_with_context_str: STRING
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_class_name: STRING
		do
			print ("ES_ADB_TEST_CASE_REPOSITORY.register_test_case%N")
			counterexamples.force (a_ce, counterexamples.count)
				-- Register timestamps
				-- FIXME: should record timestamps for all classes on the call stack.
--			across <<l_sig.class_under_test, l_sig.recipient_class>> as lt_cls_cursor loop
--				l_class_name := lt_cls_cursor.item
--				register_class_stamp (l_class_name, Void)
--			end
		end

	counterexamples_for_feature (a_feature_str: STRING): DS_ARRAYED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]
			-- Set of passing test cases for `a_feature_str'.
		require
			a_feature_str /= Void
		do
			create Result.make_equal (30)
		end

	counterexample_for_fault (a_fault: ES_ADB_FAULT): DS_ARRAYED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]
			-- Test cases related to `a_fault'.
			-- Both fields of Result are non-void, but `passing' could be empty.
		require
			a_fault /= Void
		do
			create Result.make_default
		end



feature -- Timestamps: Access

	timestamps: DS_HASH_TABLE [STRING, STRING]
		do
			Result := timestamps_storage.item
		end

	class_timestamps_log_file: PLAIN_TEXT_FILE

feature -- Timestamps: Status report

	is_logging_class_timestamps: BOOLEAN
		do
			Result := class_timestamps_log_file /= Void and then class_timestamps_log_file.is_open_write
		end

feature -- Timestamps: Query

	is_class_changed (a_class_name, a_stamp: STRING): BOOLEAN
			-- Is class with the name
		local
			l_new_stamp, l_old_stamp: STRING
		do
			l_new_stamp := stamp_of_class (a_class_name)
			Result := timestamps.has (a_class_name) and then timestamps.item (a_class_name) /~ l_new_stamp
		end

	stamp_of_class (a_name: STRING): STRING
			-- Stamp of the class with `a_name'.
		do
			check attached first_class_starts_with_name (a_name) as lt_class then
				Result := lt_class.lace_class.file_name.out + "@" + lt_class.lace_class.file_date.out
			end
		end

feature -- Timestamps: Operation

	start_logging_class_timestamps (a_config: ES_ADB_CONFIG)
			-- Start logging class timestamps into `a_file'.
		require
			a_config /= Void
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_with_path (a_config.working_directory.tested_class_timestamps_path)
			l_file.open_write
			if l_file.is_open_write then
				class_timestamps_log_file := l_file
			else
				class_timestamps_log_file := Void
			end
		end

	reset_class_timestamps_log (a_config: ES_ADB_CONFIG)
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_with_path (a_config.working_directory.tested_class_timestamps_path)
			if l_file.exists then
				l_file.wipe_out
			end
		end

	register_class_stamp (a_name: STRING; a_stamp: STRING)
			-- Register `a_stamp' as the stamp of the class with `a_name'.
		require
			a_name /= Void
		local
			l_class: CLASS_I
			l_stamp: STRING
		do
			if a_stamp = Void then
				if attached stamp_of_class (a_name) as lt_stamp then
					l_stamp := lt_stamp
				end
			else
				l_stamp := a_stamp.twin
			end

			if attached l_stamp then
				if timestamps.has (a_name) then
					check timestamps.item (a_name) ~ l_stamp end
				else
					timestamps.force (l_stamp, a_name)
					if is_logging_class_timestamps then
						log_class_timestamp (a_name, l_stamp)
					end
				end

			end
		end

	log_class_timestamp (a_name: STRING; a_stamp: STRING)
			-- Log `a_stamp' as the timestamp for class with the name `a_name'.
		do
			if is_logging_class_timestamps then
				class_timestamps_log_file.put_string (a_name + "@" + a_stamp + "%N")
				class_timestamps_log_file.flush
			end
		end

	stop_logging_class_timestamps
			--
		do
			if is_logging_class_timestamps then
				class_timestamps_log_file.close
			end
			class_timestamps_log_file := Void
		end

	load_timestamps (a_path: PATH)
			-- Load timestamps from `a_path'.
			--
			-- Each line is of form "CLASS_NAME@file_path@timestamp".
		require
			a_path /= Void
		local
			l_file: PLAIN_TEXT_FILE
			l_line: STRING
			l_segs: LIST [STRING]
			l_class_name, l_file_path, l_timestamp: STRING
		do
			create l_file.make_with_path (a_path)
			if l_file.exists then
				l_file.open_read
				if l_file.is_open_read then
					from
						l_file.read_line
					until
						l_file.end_of_file
					loop
						l_line := l_file.last_string

						l_segs := l_line.split ('@')
						if l_segs.count = 3 then
							l_class_name := l_segs.i_th (1)
							l_file_path := l_segs.i_th (2)
							l_timestamp := l_segs.i_th (3)

							if attached first_class_starts_with_name (l_class_name) then
								register_class_stamp (l_class_name, l_file_path + "@" + l_timestamp)
							end
						end

						l_file.read_line
					end
				end
			end
		end

feature -- Operation

	reset
		local
			l_storage: DS_ARRAYED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]
		do
			create l_storage.make_equal (100)
			counterexamples_storage.put (l_storage)

			timestamps_storage.put (create {DS_HASH_TABLE [STRING, STRING]}.make_equal (256))
		end

feature{NONE} -- Implementation

	counterexamples_storage: CELL [DS_ARRAYED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]]
		local
			l_storage: DS_ARRAYED_LIST [E2B_INITIAL_STATE_OF_ROUTINE]
		once
			create l_storage.make_equal (100)
			create Result.put (l_storage)
		end

	timestamps_storage: CELL [DS_HASH_TABLE [STRING, STRING]]
		once
			create Result.put (create {DS_HASH_TABLE [STRING, STRING]}.make_equal (256))
		end

note
	copyright: "Copyright (c) 1984-2014, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
