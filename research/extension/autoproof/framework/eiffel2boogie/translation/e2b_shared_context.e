note
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_SHARED_CONTEXT

inherit
	SHARED_BYTE_CONTEXT
		export {NONE} all end

feature

	boogie_universe: IV_UNIVERSE
			-- Shared boogie universe.
		do
		 	Result := boogie_universe_cell.item
		end

feature {E2B_TRANSLATE_OPTIMIZE_TASK, E2B_VERIFY_FOR_FIX_TASK} -- Access: stateful

	translation_pool: E2B_TRANSLATION_POOL
			-- Shared translation pool.
		once
			create Result.make
		end

	autoproof_errors: LINKED_LIST [E2B_AUTOPROOF_ERROR]
			-- List of autoproof errors.
		once
			create Result.make
			Result.compare_objects
		end

	result_handlers: HASH_TABLE [PROCEDURE [E2B_BOOGIE_PROCEDURE_RESULT, E2B_RESULT_GENERATOR], STRING]
			-- List of Boogie verification result handlers.
		once
			create Result.make (100)
		end

feature {NONE} -- Access: stateless

	name_translator: E2B_NAME_TRANSLATOR
			-- Shared global name translator.
		once
			create Result
		end

	translation_mapping: E2B_SPECIAL_MAPPING
			-- Shared mapping for special translations.
		once
			create Result.make
		end

	messages: E2B_MESSAGES
			-- Messages used in AutoProof.
		once
			create Result
		end

feature -- Access (public)

	options: E2B_OPTIONS
			-- Shared translation options.
		once
			create Result.make
		ensure
			class
		end

	helper: E2B_HELPER
			-- Shared helper.
		once
			create Result
		end

	e2b_error: E2B_AUTOPROOF_ERROR
			-- Error helper.
		once
			create Result
		end


feature -- Status notification.

	status_notifier_agent_cell: CELL [PROCEDURE [READABLE_STRING_GENERAL]]
			-- Once cell holding status update agent.
		once
			create Result.put (Void)
		end

	set_status (a_message: READABLE_STRING_32)
			-- Set status message.
		do
			if status_notifier_agent_cell.item /= Void then
				status_notifier_agent_cell.item.call ([a_message])
			end
		end

feature -- Byte context

	unswitch_byte_context
			-- Restore byte context to the state before the call to `switch_byte_context`.
		require
			switch_count > 0
		do
			if attached context_stack.item.current_feature as f then
				context.set_current_feature (f.c_feature)
			else
				context.clear_feature_data
			end
			if attached context_stack.item.byte_code as b then
				context.set_byte_code (b)
			end
			context_stack.remove
			context.restore_class_type_context
		ensure
			context_stack_count: switch_count = old switch_count - 1
			context_stack_unchanged: across context_stack as i all (old context_stack) [@ i.target_index] = i end
		end


	set_up_byte_context (a_type: E2B_TYPE_A)
			-- Set up byte context for `a_feature' of type `a_type'.
		do
				-- Clear byte context
			Context.clear_class_type_data
			Context.inherited_assertion.wipe_out

				-- Set up class type
			if not a_type.has_associated_class_type (Void) then
				if attached {CL_TYPE_A} a_type.type_a as l_cl_type_a then
					a_type.base_class.update_types (create {E2B_CL_TYPE_A}.make (l_cl_type_a))
				else
					check False end
				end
			end
			check a_type.has_associated_class_type (Void) end
			Context.init (a_type.associated_class_type (Void))
		end

	switch_byte_context (a_target_type: E2B_CL_TYPE_A; a_written_type: E2B_CL_TYPE_A)
			-- Update byte context to feature `f` written in `a_written_type` called on type `a_target_type`.
			-- Use `unswitch_byte_context` to restore original state.
		do
			Context.change_class_type_context
				(a_target_type.associated_class_type (Void),
				a_target_type.type_a,
				a_written_type.associated_class_type (Void),
				a_written_type.type_a)
			helper.context_stack.put ([create {E2B_FEATURE_I}.make (Context.current_feature), Context.byte_code])
			context.clear_feature_data
		ensure
			context_stack_count: helper.switch_count = old helper.switch_count + 1
			context_stack_unchanged: across old helper.context_stack as i all helper.context_stack [@ i.target_index] = i end
		end

	switch_count: NATURAL_32
			-- Number of times the byte context stack has switched.
		do
			Result := context_stack.count.as_natural_32
		ensure
			definition: Result = context_stack.count.as_natural_32
		end

feature {E2B_FEATURE_I, E2B_CLASS_C, E2B_SHARED_CONTEXT} -- Storage

	context_stack: ARRAYED_STACK [TUPLE [current_feature: detachable E2B_FEATURE_I; byte_code: detachable BYTE_CODE]]
			-- Stack of byte contexts saved by `switch_byte_context`.


feature {NONE} -- Implementation

	boogie_universe_cell: CELL [IV_UNIVERSE]
			-- Once cell holding shared boogie universe instance.
		once
			create Result.put (Void)
		end

	timer: DT_SHARED_SYSTEM_CLOCK
			-- Timer for debugging.
		once
			create Result
		end

	start_time: ARRAYED_STACK [DT_TIME]
			-- Start time set by calling 'start'.
		once
			create Result.make (5)
		end

	start_timer
		local
			l_time: DT_TIME
		do
			l_time := timer.system_clock.time_now
			start_time.extend (l_time)
		end

	stop_timer
		do
			start_time.remove
		end

	current_timer: INTEGER
		local
			l_time: DT_TIME
		do
			l_time := start_time.item
			Result := timer.system_clock.time_now.time_duration (l_time).millisecond_count
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
