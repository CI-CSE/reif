note
	description: "This class extracts counterexample traces from a ce trace file."
	author: "Li Huang"
	date: "$Date: 2014-05-26 16:24:19 +0800 (Mon, 26 May 2014) $"
	revision: "$Revision: 95176 $"

class
	AFX_CE_TRACES_OF_FAILURE

inherit
	HASHABLE
		redefine
			is_equal
		end

create
	make, make_with_traces_of_failure

feature{NONE} -- Initialization

	make (a_target_class: CLASS_C; a_target_routine: FEATURE_I; a_path: STRING_32)
			-- Initialization.
		require
			a_path /= Void
		local
			l_file_name: STRING
		do
			target_class := a_target_class
			target_routine := a_target_routine
			create ce_traces.make (0)
			location := a_path.twin
			l_file_name := location.split ('\').last
			-- TODO: get the name of target class and target routine from the path
			read_traces_from_file
			split_traces
		end

	make_with_traces_of_failure (a_trace_of_failure: like Current)
			-- Initialize with `a_trace_of_routine'
		do
			target_class := a_trace_of_failure.target_class
			target_routine := a_trace_of_failure.target_routine
			create ce_traces.make (0)
		end

feature -- Access

	location: STRING_32
			-- Location of the test.

	ce_traces: ARRAYED_LIST [AFX_CE_TRACE]
			-- Counterexample traces.

	trace_file_content: STRING_32
			-- Content of the trace file

	target_class: CLASS_C
			-- Class under fixing

	target_routine: FEATURE_I
			-- Routine under fixing

	error_index: INTEGER
			-- The index of verification failure

feature

	read_traces_from_file
			-- Read counterexample traces from the given file.
		local
			l_file: PLAIN_TEXT_FILE
		do
			create l_file.make_open_read (location)
			-- create l_file.make_open_read ("C:\Users\HP\Desktop\ACCOUNT_1_ce_traces_1.txt") -- it works
			-- create l_file.make_open_read ("D:\Eiffel_Projects\projects\account\EIFGENs\account\Data\AutoFix\temp\ACCOUNT_1_ce_traces_1.txt")
			if l_file.access_exists then -- read trace file
				l_file.open_read
				l_file.read_stream (100000000)
				if attached trace_file_content then
					trace_file_content.copy (l_file.last_string)
				else
					create trace_file_content.make_empty
					trace_file_content.copy (l_file.last_string)
				end
			end
		end


	split_traces
			-- Split the content of the trace file into a list of traces
		require
		 	trace_not_empty: not trace_file_content.is_empty
		local
			i, end_of_trace: INTEGER
			l_trace_str: STRING_32
			l_trace: AFX_CE_TRACE
		do
			from
				i := 1; l_trace_str := ""
			until
				i = trace_file_content.count
			loop
				end_of_trace := trace_file_content.substring_index ("TRACE_END", i)
				if end_of_trace /= 0 then
					l_trace_str.copy (trace_file_content.substring (i, end_of_trace - 1))
					create l_trace.make (target_class, target_routine, l_trace_str)
					ce_traces.extend (l_trace)
					i := end_of_trace + 9
				else
					i := trace_file_content.count
				end
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

;note
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
