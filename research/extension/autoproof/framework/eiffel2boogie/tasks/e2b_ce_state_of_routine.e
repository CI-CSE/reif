note
	description: "This class extracts heap states from counterexamples."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_CE_STATE_OF_ROUTINE

inherit
	E2B_SHARED_CONTEXT

create
	make

feature -- Initialize

	make (a_target_feature: detachable E2B_FEATURE_I; a_target_class: detachable E2B_CLASS_C;
	a_ce: E2B_BOOGIE_COUNTEREXAMPLE; a_heap_name: detachable STRING)
		-- Pass Void `a_heap_name` to use the initial state.
		do
			target_feature := a_target_feature
			target_class := a_target_class
			ce := a_ce
			heap_name := a_heap_name
			create initial_values.make (0)

			if a_heap_name = Void then
				heap_name := "Heap"
			end

			fill_states
		end

feature -- Data

	ce: E2B_BOOGIE_COUNTEREXAMPLE
			-- Mapping from class.routine to a set of counterexamples

	target_feature: E2B_FEATURE_I
			-- Feature under verification

	target_class: E2B_CLASS_C
			-- Class of the target feature

	initial_values: HASH_TABLE [STRING, STRING]
			-- Mapping from objects or object fields to the corresponding value

	final_values: detachable HASH_TABLE [STRING, STRING]
			-- Same as `initial_values` but for the last available heap.
			-- Void if only one heap is available
			-- (which is available through `initial_values`)

	heap_name: STRING
			-- Name of the Heap state object to use.

feature -- Get initial state

	fill_states
		local
			heaps: like initial_values_by_heap
			max_n: INTEGER
			max_k: STRING
			parts: LIST [STRING]
			num: INTEGER
		do
			heaps := initial_values_by_heap
			initial_values := heaps ["Heap"]

			final_values := Void
			max_n := -1
			if heaps.count > 1 then
				across heaps.current_keys as k loop
					parts := k.split ('@')
					if parts.count > 1 then
						num := parts.last.to_integer
						if num > max_n then
							max_n := num
							max_k := k
						end
					end
				end
				if max_k /= Void then
					final_values := heaps [max_k]
				end
			end
		end

	initial_values_by_heap: HASH_TABLE [HASH_TABLE [STRING, STRING], STRING]
			-- Initial values grouped by heap.
			-- Shape of result is Heap -> [Object -> Value].
		local
			map: like ce.functions.item
			values: HASH_TABLE [STRING, STRING]
			heap, raw_new_heap, new_heap: STRING
			obj_raw, obj, field_raw, field, value_raw, value: STRING
		do
			create Result.make (0)

			map := ce.functions ["MapType0Select"]

			across map as case loop
				if case.args /= Void then
					check case.args.count = 3 then end
					raw_new_heap := case.args [1]
					if attached ce.raw_to_name [raw_new_heap] as heap_names then
						new_heap := heap_names.first
					else
						new_heap := raw_new_heap
					end
					if heap /~ new_heap then
						if heap /= Void and then not values.is_empty then
							Result [heap] := values
						end

						heap := new_heap
						create values.make (0)
					end

					obj_raw := case.args [2]
					if obj_raw /~ ce.name_to_raw ["Void"] then
						if attached ce.raw_to_name [obj_raw] as obj_names then
							obj := obj_names.first
						else
							obj := obj_raw
						end

						field_raw := case.args [3]
						if attached ce.raw_to_name [field_raw] as field_names then
							field := field_names.first
						else
							field := field_raw
						end

						if not is_ignored_field (obj, field) then
							value_raw := case.res
							if is_abstract_value (value_raw)
								and then attached ce.raw_to_name [value_raw] as value_names then
								value := value_names.first
							else
								value := value_raw
							end
							values [safe_name (obj) + "." + field] := value
						end
					end
				end
			end
			if heap /= Void and then not values.is_empty then
				Result [heap] := values
			end
		end

	is_ignored_field (object, field: STRING): BOOLEAN
		do
			Result := object ~ "boxed_true"
				or else object ~ "boxed_false"
					or else field ~ "allocated"
		end

	container_size_named (a_var: STRING): STRING
			-- Size of the container named `a_var'
		do
			Result := "" -- TODO: apply Seq#Length function
		end

	container_item_named (a_var: STRING; i: STRING): STRING
			-- The ith element of the container named `a_var'
		do
			Result := "" -- TODO: apply Seq#Item function
		end

	value_named (a_var: STRING): STRING
			-- Initial value of `a_var'
		do
			Result := ce.name_to_raw [a_var]
		end

	is_abstract_value (value: STRING): BOOLEAN
			-- Is the `value' an abstract value?
		do
			Result := value.starts_with ("T@U")
		end

	is_aliased_with_existed_object (object_name: STRING): BOOLEAN
			-- Is this objected aliased with other object?
		do
			Result := ce.raw_to_name [ce.name_to_raw [object_name]].count > 1
		end

	alias_groups: LIST [LIST [STRING]]
			-- Groups of objects having the same value
		local
			list: LINKED_LIST [STRING]
		do
			create {LINKED_LIST [LINKED_LIST [STRING]]} Result.make
			across ce.raw_to_name.current_keys as k loop
				if ce.raw_to_name [k].count > 1 then
					create list.make
					across ce.raw_to_name [k] as r loop
						list.extend (safe_name (r))
					end
					Result.extend (list)
				end
			end
		end


	safe_name (name: STRING): STRING
			-- Get a valid name
		local
			words: LIST [STRING]
		do
			if name.has_substring ("@@") then -- this is usually the form of arguments; get rid of the prefix and suffix to get the actual argument name
				words := name.split ('@')
				Result := words.first
			else
				Result := name
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

