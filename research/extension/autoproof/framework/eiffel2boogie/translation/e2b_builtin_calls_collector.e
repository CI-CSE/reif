note
	description: "[
		Byte node visitor to collect information about calls to various built-in features.
	]"
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_BUILTIN_CALLS_COLLECTOR

inherit

	BYTE_NODE_ITERATOR
		redefine
			process_feature_b,
			process_nested_b
		end

	E2B_SHARED_CONTEXT

	SHARED_NAMES_HEAP

	SHARED_WORKBENCH
		export {NONE} all end

	INTERNAL_COMPILER_STRING_EXPORTER
		export {NONE} all end

feature -- Status report

	is_any_target: BOOLEAN
			-- Does this collector consider calls on targets other than `Current'?

feature -- Status setting

	set_any_target
			-- Set `is_any_target' to True.
		do
			is_any_target := True
		end

feature -- Results

	has_attribute (a_name: READABLE_STRING_8): BOOLEAN
			-- Is attribute `a_name' mentioned?
		do
			if a_name.same_string ("observers") then
				Result := has_observers
			elseif a_name.same_string ("subjects") then
				Result := has_subjects
			elseif a_name.same_string ("owns") then
				Result := has_owns
			end
		end

	has_observers: BOOLEAN
			-- Is `observers' mentioned?

	has_subjects: BOOLEAN
			-- Is `subjects' mentioned?

	has_owns: BOOLEAN
			-- Is `owns' mentioned?

	is_inv_unfriendly: BOOLEAN
			-- Are `closed' or `owner' mentioned?

feature -- Processing

	process_feature_b (a_node: FEATURE_B)
			-- <Precursor>
		local
			l_name: STRING
			l_feature: E2B_FEATURE_I
		do
			Precursor (a_node)
			l_name := names_heap.item (a_node.feature_name_id)
			if a_node.routine_id > 0 then
				l_feature := create {E2B_FEATURE_I}.make (system.class_of_id (a_node.written_in).feature_of_rout_id (a_node.routine_id))
			end
			if l_name.same_string ("observers") then
				has_observers := True
			elseif l_name.same_string ("subjects") then
				has_subjects := True
			elseif l_name.same_string ("owns") then
				has_owns := True
			elseif
				l_name.same_string ("closed") or
				l_name.same_string ("is_open") or
				l_name.same_string ("is_wrapped") or
				l_name.same_string ("owner") or
				l_name.same_string ("is_free") or
				(attached l_feature and then l_feature.is_invariant_unfriendly)
			then
				is_inv_unfriendly := True
			end
		end

	process_nested_b (a_node: NESTED_B)
			-- <Precursor>
		do
			if attached {CURRENT_B} a_node.target then
				a_node.message.process (Current)
			else
				if is_any_target then
						-- Consider this access if any targets should be considered
					a_node.message.process (Current)
				end
				a_node.target.process (Current)
			end
		end

note
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
