note
	description: "Summary description for {ES_ADB_FAULT_REPOSITORY}."
	author: ""
	date: "$Date: 2014-06-22 06:38:32 +0800 (Sun, 22 Jun 2014) $"
	revision: "$Revision: 95320 $"

class
	ES_ADB_PROOF_FAILURE_REPOSITORY

feature -- Access

	failure_repository: DS_ARRAYED_LIST [ES_ADB_PROOF_FAILURE]
			-- Current repository.
		do
			Result := failure_repository_storage.item
		end

	proof_failure_file: PLAIN_TEXT_FILE


feature -- Query

	filtered_failures (a_filter: PREDICATE [TUPLE [ES_ADB_PROOF_FAILURE]]): DS_ARRAYED_LIST [ES_ADB_PROOF_FAILURE]
			-- List of faults satisfying `a_filter'.
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [ES_ADB_PROOF_FAILURE]
		do
			create Result.make_equal (failure_repository.count)
			from
				l_cursor := failure_repository.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if a_filter.item ([l_cursor.item]) then
					Result.force_last (l_cursor.item)
				end
				l_cursor.forth
			end
		end

feature -- Operation

	register_proof_failure (a_msg: STRING; a_directory: PATH)
		local
			l_failure: ES_ADB_PROOF_FAILURE
			l_target_class, l_target_feature, l_exception_code, l_line_number, l_failure_msg: STRING
			l_components: LIST [STRING]
		do
			l_components := a_msg.split ({EWB_BOOGIE_VERIFICATION}.msg_seperator)
			if not l_components.is_empty and then l_components.count >= 5 then
				l_target_class := l_components [1]
				l_target_feature := l_components [2]
				l_exception_code := l_components [3]
				l_line_number := l_components [4]
				l_failure_msg := l_components [5]
				create l_failure.make (l_target_class, l_target_feature, l_exception_code, l_line_number, l_failure_msg)
				failure_repository.put (l_failure, failure_repository.count + 1)
				if not attached proof_failure_file then
					create proof_failure_file.make_create_read_write (a_directory.extended ("proof_failures.txt").out)
				end
				proof_failure_file.put_string (a_msg + "%N")
				proof_failure_file.flush
			end
		end

	reset
			-- Reset `fault_repository'.
		do
			failure_repository_storage.put (create {DS_ARRAYED_LIST [ES_ADB_PROOF_FAILURE]}.make_equal (100))
		end

feature {NONE} -- Implementation

	failure_repository_storage: CELL [DS_ARRAYED_LIST [ES_ADB_PROOF_FAILURE]]
			-- Shared storage for `fault_repository'.
		once
			create Result.put (create {DS_ARRAYED_LIST [ES_ADB_PROOF_FAILURE]}.make_equal (100))
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
