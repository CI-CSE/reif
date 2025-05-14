note
	description: "Summary description for {ES_ADB_TEST_CASE_REPOSITORY}."
	author: ""
	date: "$Date: 2014-06-22 06:38:32 +0800 (Sun, 22 Jun 2014) $"
	revision: "$Revision: 95320 $"

class
	AFX_CE_TRACE_REPOSITORY

inherit

--	DS_ARRAYED_LIST [AFX_CE_TRACE]
--		rename
--			make as make_hash_table,
--			make_default as make_default_hash_table
--		undefine
--			is_equal, copy
--		end

	AFX_SHARED_SESSION
		undefine
			is_equal, copy
		end

	AFX_UTILITY
		undefine
			is_equal, copy
		end

	EPA_UTILITY


feature -- Initialization

--	make (a_size: INTEGER)
--			 Initialization.
--		require
--			size_big_enough: a_size > 0
--		do
--			make_equal (a_size)
--		end



feature -- CE traces: Access

	ce_traces: DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE]
		do
			Result := ce_traces_storage.item
		end

feature -- CE traces: Access

	register_ce_traces (a_ce_traces: AFX_CE_TRACES_OF_FAILURE)
			-- Register `a_test' with Current.
		require
			a_ce_traces /= Void
		local
			l_feature_with_context_str: STRING
			l_feature_with_context: EPA_FEATURE_WITH_CONTEXT_CLASS
			l_class_name: STRING
		do
			ce_traces.put (a_ce_traces, ce_traces.count + 1)
			-- Register timestamps
			-- FIXME: should record timestamps for all classes on the call stack.
--			across <<l_sig.class_under_test, l_sig.recipient_class>> as lt_cls_cursor loop
--				l_class_name := lt_cls_cursor.item
--				register_class_stamp (l_class_name, Void)
--			end

		end

	ce_traces_for_feature (a_feature_str: STRING): DS_ARRAYED_LIST [AFX_CE_TRACE]
			-- Set of passing test cases for `a_feature_str'.
		require
			a_feature_str /= Void
		do
			create Result.make_equal (30)
		end

--	ce_traces_for_fault (a_fault: ES_ADB_FAULT): DS_ARRAYED_LIST [AFX_CE_TRACE]
--			-- Test cases related to `a_fault'.
--			-- Both fields of Result are non-void, but `passing' could be empty.
--		require
--			a_fault /= Void
--		do
--			create Result.make_default
--		end


feature -- Derived repository

	derived_compound_repository (a_features_to_monitor: DS_ARRAYED_LIST [AFX_FEATURE_TO_MONITOR]; a_use_aspect: BOOLEAN): like Current
		local
			l_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]
			l_trace_of_failure, r_trace_of_failure: AFX_CE_TRACES_OF_FAILURE
			l_ce_traces: DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE]
		do
			create Result
			l_map := features_to_monitor_by_names (a_features_to_monitor)

			l_ce_traces := ce_traces.twin

			Result.reset
			from l_ce_traces.start
			until l_ce_traces.after
			loop
				l_trace_of_failure := l_ce_traces.item_for_iteration
				create r_trace_of_failure.make_with_traces_of_failure (l_trace_of_failure)
				r_trace_of_failure.ce_traces.wipe_out
				across l_trace_of_failure.ce_traces as t loop
					r_trace_of_failure.ce_traces.force (t.item.derived_compound_trace (l_map, a_use_aspect))
				end
				Result.ce_traces.force (r_trace_of_failure, Result.ce_traces.count + 1)
				l_ce_traces.forth
			end
		end


feature -- Operation

	reset
		local
			l_storage: DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE]
		do
			create l_storage.make_equal (20)
			ce_traces_storage.put (l_storage)

			-- timestamps_storage.put (create {DS_HASH_TABLE [STRING, STRING]}.make_equal (256))
		end

feature -- Constant

	Default_repository_capacity: INTEGER = 10
			-- Default size for the repository.

feature {NONE} -- Implementation

	ce_traces_storage: CELL [DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE]]
		local
			l_storage: DS_ARRAYED_LIST [AFX_CE_TRACES_OF_FAILURE]
		once
			create l_storage.make_equal (20)
			create Result.put (l_storage)
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
