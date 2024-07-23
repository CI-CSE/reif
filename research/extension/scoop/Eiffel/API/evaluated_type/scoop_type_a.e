note
description: "Changes for TYPE_A to support SCOOP"

class
SCOOP_TYPE_A

inherit
	TYPE_A
		redefine
			is_processor_attachable_to
		end

feature

	processor_tag : attached PROCESSOR_TAG_TYPE
			-- Added for SCOOP: So far the type checker does not support explicit processor specifications. Thus no type in the system will have an explicit processor specification.
		require
			already_separate: is_separate
		do
			create Result.make_top
		end

	is_processor_attachable_to (other: TYPE_A): BOOLEAN
			-- <Precursor>
		do
			if (is_separate and system.is_scoop) implies other.is_separate then
					-- General rule.
				Result := True
			elseif attached context.current_feature as f and then
				attached f.body as b and then attached b.indexes as l_indexing_clause then
					-- Handle features explicitly ignoring separate status of types.
				from
					l_indexing_clause.start
				until
					l_indexing_clause.after
				loop
					if l_indexing_clause.item.tag.name_32.is_equal (once "ignore_invalid_separate_reattachment") then
						if across l_indexing_clause.item.index_list as l
							 some l.item.string_value_32.is_case_insensitive_equal ("True") end then
							Result := True
							l_indexing_clause.finish
						else
							l_indexing_clause.forth
						end
					else
						l_indexing_clause.forth
					end
				end
			end
		end
end
