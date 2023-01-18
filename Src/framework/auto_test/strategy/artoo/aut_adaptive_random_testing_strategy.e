note
	description: "Testing strategy for adaptive random testing"
	author: "Ilinca Ciupa"
	date: "$Date$"
	revision: "$Revision$"

class AUT_ADAPTIVE_RANDOM_TESTING_STRATEGY

inherit
	AUT_RANDOM_STRATEGY
		redefine
			make, select_new_sub_task
		end

create
	make

feature {NONE} -- Initialization

	make (an_interpreter: like interpreter; a_system: like system;
		  an_error_handler: like error_handler) 
			-- Create new strategy.
		do
			Precursor (a_system, an_interpreter, an_error_handler)
			create distances.make_default
		end

feature -- Execution

	select_new_sub_task is
		local
			caller: AUT_ART_FEATURE_CALLER
		do
			queue.select_next
			selected_feature := queue.last_feature
			create caller.make (universe, interpreter, queue, error_handler)
			caller.set_feature_and_type (selected_feature.feature_, selected_feature.type)
			caller.set_distances (distances)
			sub_task := caller
			sub_task.start
		end


feature {NONE} -- Implementation

	distances: DS_HASH_TABLE [DS_HASH_TABLE [DOUBLE, STRING], STRING]
			-- Calculated distances: keys are names of stored variables (in the form "class_name.feature_name_position")
			-- and items are hashtables, whose keys are names of alive variables (in the usual form of v_1, etc)
			-- and items are calculated distances


invariant
	distances_not_void: distances /= Void

note
	copyright: "Copyright (c) 1984-2022, Eiffel Software"
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
