note
	description: "Helper functions for Eiffel to Boogie translation."

frozen class
	E2B_HELPER

inherit

	E2B_SHARED_CONTEXT
		export
			{NONE}
				all
			{ANY}
				deep_twin,
				is_deep_equal,
				messages,
				name_translator,
				standard_is_equal,
				translation_mapping,
				translation_pool
		end

	SHARED_WORKBENCH
		export {NONE} all end

	SHARED_BYTE_CONTEXT
		export {NONE} all end

	SHARED_SERVER
		export {NONE} all end

	IV_SHARED_TYPES
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

feature -- Cache control

	reset
			-- Reset cached data.
		do
			map_access_feature_cache.wipe_out
			flat_model_cache.wipe_out
			ghost_attribute_cache.wipe_out
			internal_counter.put (0)
				-- Reset invariant checks
			; (create {E2B_TYPE_TRANSLATOR}).invariant_check_cache.wipe_out
				-- Reset type varibale counter
			; (create {IV_VAR_TYPE}.reset).do_nothing
			create context_stack.make (1)
		end

feature -- General note helpers

	note_values (a_indexing_clause: INDEXING_CLAUSE_AS; a_tag: READABLE_STRING_8): ARRAYED_LIST [READABLE_STRING_8]
			-- List of note values of tag `a_tag'.
		do
			create Result.make (3)
			Result.compare_objects
			across
				a_indexing_clause as i
			loop
				if i.tag.name.same_string (a_tag) then
					across
						i.index_list as v
					loop
						Result.extend (if attached {STRING_AS} v as s then s.value else v.string_value end)
						-- print ("note value: " + Result.last + "%N")
					end
				end
			end
		end

feature -- Ownership helpers

	is_clause_reads (a_clause: ASSERT_B): BOOLEAN
			-- Is contract clause `a_clause' a reads clause?
		do
			Result := attached {FEATURE_B} a_clause.expr as l_call and then (l_call.feature_name ~ "reads" or l_call.feature_name ~ "reads_field" or l_call.feature_name ~ "reads_model")
		end

	is_clause_modify (a_clause: ASSERT_B): BOOLEAN
			-- Is contract clause `a_clause' a modify clause?
		do
			Result := attached {FEATURE_B} a_clause.expr as l_call and then (l_call.feature_name ~ "modify" or l_call.feature_name ~ "modify_field" or l_call.feature_name ~ "modify_model" or l_call.feature_name ~ "modify_agent")
		end

	is_clause_decreases (a_clause: ASSERT_B): BOOLEAN
			-- Is contract clause `a_clause' a decreases clause?
		do
			Result := attached {FEATURE_B} a_clause.expr as l_call and then l_call.feature_name ~ "decreases"
		end

feature -- String helpers

	feature_for_call_access (a_node: CALL_ACCESS_B; a_target_type: E2B_TYPE_A): E2B_FEATURE_I
			-- Feature represented by `a_node'.
		do
			check a_target_type.base_class.is_conforming_or_non_conforming_parent_class (create {E2B_CLASS_C}.make (system.class_of_id (a_node.written_in))) end
			Result := a_target_type.base_class.feature_of_rout_id (a_node.routine_id)
			Result := Result.instantiated (a_target_type)
			check Result /= Void end
		end

	set_any_type: detachable E2B_CL_TYPE_A
			-- give type of element in owns if not present or not a class_type return Void
		local l_type: CL_TYPE_A
		do
			if attached system.any_type.base_class.feature_named ("owns") as f then
				l_type := {CL_TYPE_A} / f.type
				if attached {CL_TYPE_A} l_type then
					create Result.make (l_type)
				end
			else
				e2b_error.add_unsupported_error (Void, {STRING_32} "Feature `owns` is not found in class `ANY`.", 0)
			end
		end

	sequence_any_type: detachable E2B_CL_TYPE_A
			-- Type MML_SET [ANY] (supplier of ANY).
		local l_type: CL_TYPE_A
		do
			if attached system.any_type.base_class.feature_named ("passed_blocks") as f then
				l_type := {CL_TYPE_A} / f.type
				if attached {CL_TYPE_A} l_type then
					create Result.make (l_type)
				end
			else
				(create {E2B_AUTOPROOF_ERROR}).add_unsupported_error (Void, {STRING_32} "Feature `passed_blocks` is not found in class `ANY`.", 0)
			end
		end

feature -- Other

	internal_counter: CELL [INTEGER]
			-- Internal shared counter.
		once
			create Result.put (0)
		end

	unique_identifier (a_name: READABLE_STRING_8): READABLE_STRING_8
			-- Unique identifier with base name `a_name'.
		do
			internal_counter.put (internal_counter.item + 1)
			check internal_counter.item >= 0 end
			Result := a_name + "_" + internal_counter.item.out
		end

feature -- Implementation

	to_camel_case (a_name: STRING): STRING
			-- Eiffel-style identifier `a_name' converted to camel case.
		local
			i: INTEGER
		do
			Result := a_name.string
			from
				i := 1
			until
				not Result.valid_index (i)
			loop
				Result.replace_substring (Result.substring (i, i).as_upper, i, i)
				i := Result.index_of ('_', i)
				if Result.valid_index (i) then
					Result.remove (i)
				end
			end
		end

	map_access_feature_cache: HASH_TABLE [E2B_FEATURE_I, INTEGER]
			-- Cache of the feature that translates to map access for each model class.
		once
			create Result.make (50)
		end

	flat_model_cache: HASH_TABLE [ARRAYED_LIST [E2B_FEATURE_I], INTEGER]
			-- Cache of a list of all model queries for each class.
		once
			create Result.make (50)
		end

	ghost_attribute_cache: HASH_TABLE [ARRAYED_LIST [E2B_FEATURE_I], INTEGER]
			-- Cache of a list of all ghost attributes for each class.
		once
			create Result.make (50)
		end

note
	date: "$Date$"
	revision: "$Revision$"
	copyright:
		"Copyright (c) 2012-2015 ETH Zurich",
		"Copyright (c) 2018-2019 Politecnico di Milano",
		"Copyright (c) 2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Nadia Polikarpova", "Alexander Kogtenkov"
	license: "GNU General Public License"
	license_name: "GPL"
	EIS: "name=GPL", "src=https://www.gnu.org/licenses/gpl.html", "tag=license"
	copying: "[
		This program is free software; you can redistribute it and/or modify it under the terms of
		the GNU General Public License as published by the Free Software Foundation; either version 1,
		or (at your option) any later version.

		This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
		without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
		See the GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along with this program.
		If not, see <https://www.gnu.org/licenses/>.
	]"

end
