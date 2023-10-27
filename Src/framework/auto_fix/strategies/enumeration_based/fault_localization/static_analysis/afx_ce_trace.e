note
	description: "This class extracts counterexample traces from files."
	author: "Li Huang"
	date: "$Date: 2014-05-26 16:24:19 +0800 (Mon, 26 May 2014) $"
	revision: "$Revision: 95176 $"

class
	AFX_CE_TRACE

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make, make_empty

feature {NONE} -- Initialization

	make (a_target_class: CLASS_C; a_target_routine: FEATURE_I ; a_data: STRING_32)
			-- Initialization.
		require
			a_data /= Void
		do
			target_class := a_target_class
			target_routine := a_target_routine

			trace_content := ""
			trace_content.copy (a_data)
			create ce_trace.make (0)
			split_states
			extract_states
				-- location := a_path.twin
				-- read_traces
				-- split_traces
				-- create test_case_signature.make_with_string (location.entry.out)
				-- TODO: read the trace files and create traces
				-- An object contains n (number of iteration given by the user) counrerexample traces, generated for the same error
		end

	make_empty
		do
			create ce_trace.make (0)
		end

feature -- Access

	location: PATH
			-- Location of the test.

	ce_trace: ARRAYED_LIST [AFX_CE_STATE]
			-- Counterexample traces.

	trace_content: STRING_32
			-- String representation of the trace.

	target_class: CLASS_C
			-- Class under fixing

	target_routine: FEATURE_I
			-- Routine under fixing

	error_index: INTEGER
			-- The index of verification failure

feature {NONE}

	split_states
			-- Split the trace content into a list of states
	require
	 	trace_not_empty: not trace_content.is_empty
	local
		i, end_of_state: INTEGER
		l_state_str: STRING_32
		l_state: AFX_CE_STATE
		l_index: INTEGER
	do
		from
			i := 1; l_state_str := ""
		until
			i = trace_content.count
		loop
			end_of_state := trace_content.substring_index ("STATE_END", i)
			if end_of_state /= 0 then
				l_state_str.copy (trace_content.substring (i, end_of_state - 1))
				-- models.force (model, models.count + 1)
				l_index := l_index + 1
				create l_state.make (target_class, target_routine, l_index, l_state_str)
				ce_trace.extend (l_state)
				i := end_of_state + 9
			else
				i := trace_content.count
			end
		end
	end

feature -- Trace interpretation

	extract_states
		do

		end

	derived_compound_trace (a_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]; a_use_aspect: BOOLEAN): AFX_CE_TRACE
		local
			l_state: AFX_CE_STATE
			l_feature: AFX_FEATURE_TO_MONITOR
			l_name: STRING
		do
			create Result.make_empty

			from ce_trace.start
			until ce_trace.after
			loop
				l_state := ce_trace.item_for_iteration
				Result.ce_trace.force (l_state.derived_state (a_map, a_use_aspect))

				ce_trace.forth
			end
		end

feature -- Query

	hash_code: INTEGER
			-- <Precursor>
		do
				-- Result := test_case_signature.hash_code
		end

	is_equal (other: like Current): BOOLEAN
			-- <Precursor>
		do
			if other /= Void then
				Result := location ~ other.location
			end
		end

;

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
