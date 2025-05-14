note
	description: "Summary description for {ES_ADB_CE_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	AFX_CE_STATE

create
	make, make_with_state

feature {NONE} -- Initialize

	make (a_target_class: CLASS_C; a_target_routine: FEATURE_I; a_index: INTEGER; a_data: STRING_32)
			-- Instantiate a ce state from its string representation
		do
				-- print ("AFX_CE_STATE.make%N")
			target_class := a_target_class
			target_routine := a_target_routine
			index := a_index
			get_valuations (a_data)
			create state.make_from_ce_state (valuations, target_class, target_routine)
		end

	make_with_state (a_state: EPA_STATE; a_index: INTEGER)
		do
			state := a_state.twin
			target_class := state.class_
			target_routine := state.feature_
			index := a_index
		end
feature

	target_class: CLASS_C
			-- Class under analysis

	target_routine: FEATURE_I
			-- Feature under analysis

	valuations: HASH_TABLE [STRING, STRING]
			-- Key: name of the variable
			-- Value: value of the variable in the state
		once
			create Result.make (0)
		end

	state: EPA_STATE

	index: INTEGER

feature {NONE} -- Implementation

	get_valuations (a_str: STRING_32)
			-- Get value pairs from `a_str'
		local
			l_lines, l_exprs: LIST [STRING_32]
		do
			valuations.wipe_out
			l_lines := a_str.split ('%N')
			across l_lines as l loop
				l_exprs := l.item.split (' ')
				if attached l_exprs and then not l_exprs.last.is_empty and then not valuations.has (l_exprs.first) then
					valuations.extend (safe_value (l_exprs.last), l_exprs.first)
				end
			end

			-- Add valuations for constants in the context class
			across target_class.constant_features as const loop
				valuations.extend (const.item.value_32, const.item.name_8)
			end
		end

	safe_value (a_value: STRING): STRING
		require
			not a_value.is_empty
		do
			Result := a_value.twin
			if Result.has ('(') then
				Result.replace_substring_all ("(","")
				Result.replace_substring_all (")","")
			end
		end

feature -- Derived state

	derived_state (a_map: DS_HASH_TABLE [AFX_FEATURE_TO_MONITOR, STRING]; a_use_aspect: BOOLEAN): AFX_CE_STATE
			-- Derived state from the Current, based on `a_derived_skeleton'.
		require
			a_map /= Void
		local
			l_qualified_feature_name: STRING
			l_feature: AFX_FEATURE_TO_MONITOR
			l_skeletons_at_breakpoints: DS_HASH_TABLE [EPA_STATE_SKELETON, INTEGER_32]

			l_skeleton: EPA_STATE_SKELETON
			l_state: EPA_STATE
			l_creator: EPA_AST_EXPRESSION_SAFE_CREATOR
			l_exp: EPA_AST_EXPRESSION
			l_equation: EPA_EQUATION
			l_index: INTEGER
		do
			l_qualified_feature_name := state.class_.name_in_upper + "." + state.feature_.feature_name_32

				-- Skeleton for the breakpoint of the state
			check a_map.has (l_qualified_feature_name) end
				-- print ("kkkk1" + l_qualified_feature_name + " " + a_map.has (l_qualified_feature_name).out + "%N")
				-- across a_map.keys as k loop
				-- 	print (k.item + a_map.at (k.item).feature_.external_name + "%N")
				-- end
			l_feature := a_map.item (l_qualified_feature_name)
			l_skeletons_at_breakpoints := l_feature.skeletons_at_breakpoints
				-- l_skeleton := l_feature.skeletons_at_breakpoints
				-- get skeleton from body and contract
				-- check l_skeletons_at_breakpoints.has (l_bpt) end

			across l_skeletons_at_breakpoints as exp loop
				l_skeleton := exp.item -- l_skeletons_at_breakpoints.item (l_bpt)

				from
					create l_state.make (state.count, state.class_, state.feature_)
					l_skeleton.start
				until
					l_skeleton.after
				loop

					if attached {AFX_PROGRAM_STATE_ASPECT} l_skeleton.item_for_iteration as lv_aspect then
						-- print ("aspecttt: " + lv_aspect.text + "%N")
						lv_aspect.evaluate (state)
						if a_use_aspect then
							create l_equation.make (lv_aspect, lv_aspect.last_value)
							l_state.force (l_equation)
								-- print ("aspect result1: " + lv_aspect.last_value.out + "%N")
						else
							l_exp := l_creator.safe_create_with_expression (lv_aspect)
							if l_exp /= Void then
								create l_equation.make (l_exp, lv_aspect.last_value)
								l_state.force (l_equation)
									-- print ("aspect result2: " + lv_aspect.last_value.out + "%N")
							end
						end
					end
					l_index := l_index + 1
					l_skeleton.forth
				end
			--	l_bpt := l_bpt + 1
--			end
			end

			across state as equ loop
				l_state.force (equ.item)
			end

			create Result.make_with_state (l_state, index)
			across l_state as equ loop
			 	-- print ("derived equ: " + equ.item.text + "%N")
			end

		end

end
