note
	description: "Value in a counterexample (E2B_CE_STATE_OF_ROUTINE)"

deferred class
	E2B_CE_VALUE

feature
	copied: like Current
		deferred
		end

	multi_line_message_lines (trace: E2B_CE_TRACE_OF_ROUTINE): LIST [READABLE_STRING_32]
		deferred
		end

	inline_text (trace: E2B_CE_TRACE_OF_ROUTINE): detachable READABLE_STRING_32
		do
			-- Void by default
		end
end
