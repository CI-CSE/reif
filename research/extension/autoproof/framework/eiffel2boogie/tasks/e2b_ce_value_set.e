note
	description: "Set represented in a counterexample"

class
	E2B_CE_VALUE_SET

inherit
	E2B_CE_VALUE
		redefine
			inline_text
		end

create
	make, make_copied

feature {NONE}
	make
		do
		end

	make_copied (other: E2B_CE_VALUE_SET)
		do
			is_empty := other.is_empty
			type := other.type
		end

feature

	update_from_set_empty (
		set_empty_case: TUPLE [args: LIST [READABLE_STRING_32]; res: READABLE_STRING_32];
		ce: E2B_BOOGIE_COUNTEREXAMPLE)
			-- Update this set using a case of the Set#Empty function
		do
			is_empty := True
			type := set_empty_case.args.first
		end

	multi_line_message_lines (trace: E2B_CE_TRACE_OF_ROUTINE): ARRAYED_LIST [READABLE_STRING_32]
		do
			create Result.make (0)
			-- No non-inline implementations for now
		end

	inline_text (trace: E2B_CE_TRACE_OF_ROUTINE): detachable READABLE_STRING_32
		do
			if is_empty then
				Result := "Set#Empty()"
				if type /= Void then
					Result := {STRING_32} "<" + trace.translate_raw (type) + ">" + Result
				end
			end
		end

	copied: E2B_CE_VALUE_SET
		do
			create Result.make_copied (Current)
		end

feature
	is_empty: BOOLEAN
			-- Is this set equal to Set#Empty() ?

	type: detachable READABLE_STRING_32
			-- Raw id of type of this set

end
