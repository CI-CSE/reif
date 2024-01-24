note
	description: "Summary description for {EPA_STATE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	EPA_STATE

inherit
	EPA_HASH_SET [EPA_EQUATION]
		rename
			make as make_set
		redefine
			key_to_hash
		end

	HASHABLE
		undefine
		    copy,
		    is_equal
		end

--	EPA_HASH_CALCULATOR
--		undefine
--		    is_equal,
--		    copy
--		end

	REFACTORING_HELPER
		undefine
			copy,
			is_equal
		end

	SHARED_TYPES
		undefine
		    copy,
		    is_equal
		end

	DEBUG_OUTPUT
		undefine
			copy,
			is_equal
		end

	EPA_CONSTANTS
		undefine
			copy,
			is_equal
		end

	EPA_SHARED_EQUALITY_TESTERS
		undefine
			copy,
			is_equal
		end

create
	make,
	make_chaos,
	make_from_ce_state,
	make_from_object_state,
	make_from_expression_value_pairs,
	make_from_state,
	make_from_string

feature{NONE} -- Initialization

	make (n: INTEGER; a_class: like class_; a_feature: like feature_)
			-- Create an empty container and allocate
			-- memory space for at least `n' items.
			-- Set equality tester to {AFX_PREDICATE_EQUALITY_TESTER}.			
		require
			a_class_attached: a_class /= Void
		do
			class_ := a_class
			feature_ := a_feature
			make_set (n)
			set_equality_tester (create {EPA_EQUATION_EQUALITY_TESTER})
		end

	make_from_ce_state (a_state: HASH_TABLE [STRING, STRING]; a_class: like class_; a_feature: like feature_)
			-- Initialize Current with queries and values from `a_state' for `a_class' and `a_feature'.
			-- Key of `a_state' is query name, value is the result of the query.
		require
			a_class_attached: a_class /= Void
		do
			make (a_state.count, a_class, a_feature)

			from
				a_state.start
			until
				a_state.after
			loop
				force_last (predicate_from_expression_and_value (a_state.key_for_iteration, a_state.item_for_iteration, a_class, a_feature))
				a_state.forth
			end

			derived_extra_equality
		end

	make_from_object_state (a_state: HASH_TABLE [STRING, STRING]; a_class: like class_; a_feature: like feature_)
			-- Initialize Current with queries and values from `a_state' for `a_class' and `a_feature'.
			-- Key of `a_state' is query name, value is the result of the query.
		require
			a_class_attached: a_class /= Void
		do
			make (a_state.count, a_class, a_feature)

			from
				a_state.start
			until
				a_state.after
			loop
				force_last (predicate_from_expression_and_value (a_state.key_for_iteration, a_state.item_for_iteration, a_class, a_feature))
				a_state.forth
			end
		end

	make_from_expression_value_pairs (a_exp_val: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]; a_class: like class_; a_feature: like feature_)
			-- Initialize a new state from a list of expression-value pairs
		require
			a_class_attached: a_class /= Void
		local
		    l_equation: EPA_EQUATION
		    l_cursor: DS_HASH_TABLE_CURSOR [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]
		do
		    make (a_exp_val.count, a_class, a_feature)
		    from
		    	l_cursor := a_exp_val.new_cursor
		    	l_cursor.start
		    until
		    	l_cursor.after
		    loop
		        create l_equation.make (l_cursor.key, l_cursor.item)
		        force_last (l_equation)
		    	l_cursor.forth
		    end
		end

	make_from_state (a_state: like Current; a_type: TYPE_A)
			-- Initialize a new state from `a_state', extracting only those predicates conforming to `a_type'.
		require
			class_exists: a_state.class_ /= Void
		local
		    l_type: TYPE_A
		    l_equation: EPA_EQUATION
		    l_feature_table: FEATURE_TABLE
		    l_feature_name_set: DS_HASH_SET[STRING]
		    l_feature: FEATURE_I
		    l_cursor: CURSOR
		do
		    make_set (a_state.count)
		    class_ := a_type.associated_class

		    	-- get feature names in the filtering set
		    l_feature_table := class_.feature_table
		    create l_feature_name_set.make_default
		    l_feature_name_set.set_equality_tester (string_equality_tester)
		    l_cursor := l_feature_table.cursor
		    from l_feature_table.start
		    until l_feature_table.after
		    loop
		        l_feature := l_feature_table.item_for_iteration
		        if l_feature.type /= void_type and then l_feature.argument_count = 0 then
    		    	l_feature_name_set.force (l_feature.feature_name)
		        end
		        l_feature_table.forth
		    end
		    l_feature_table.go_to (l_cursor)

		    from a_state.start
		    until a_state.after
		    loop
		        l_equation := a_state.item_for_iteration
				if l_feature_name_set.has (l_equation.expression.text) then
				    force (l_equation)
				end
		        a_state.forth
		    end
		end

	make_chaos (a_class: like class_)
			-- create a chaos state
		do
		    make (1, a_class, Void)
		    is_chaos := True
		end

	make_from_string (a_class: like class_; a_feature: like feature_; a_data: STRING)
			-- Make current state from `a_data'.
		local
			l_lines: LIST [STRING]
			l_text: STRING
			l_parts: LIST [STRING]
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_expr_str: STRING
			l_value_str: STRING
		do
			fixme ("Only support boolean and integer values for the moment. 20.12.2009 Jasonw")
			l_lines := a_data.split ('%N')
			make (l_lines.count, a_class, a_feature)
			from
				l_lines.start
			until
				l_lines.after
			loop
				l_text := l_lines.item_for_iteration
				l_text.replace_substring_all (once "%R", once "")
				if not l_text.is_empty then
					l_parts := string_slices (l_text, equation_separator)
					check l_parts.count = 2 end
					l_expr_str := l_parts.first
					l_expr_str.left_adjust
					l_expr_str.right_adjust
					l_value_str := l_parts.last
					l_value_str.left_adjust
					l_value_str.right_adjust

					create l_expr.make_with_text (a_class, a_feature, l_parts.first, a_class)
					if l_value_str.is_integer then
						create {EPA_INTEGER_VALUE} l_value.make (l_value_str.to_integer)
					elseif l_value_str.is_boolean then
						create {EPA_BOOLEAN_VALUE} l_value.make (l_value_str.to_boolean)
					else
						check not_supported: False end
					end
					force_last (create {EPA_EQUATION}.make (l_expr, l_value))
				end
				l_lines.forth
			end
		end

feature -- Access

	class_: CLASS_C
			-- Class from which Current state is derived

	feature_: detachable FEATURE_I
			-- Feature from which Current state is derived
			-- If Void, it means that Current state is derived for the whole class,
			-- instead of particular feature.

	item_with_expression_text (a_expr: STRING): detachable EPA_EQUATION
			-- Equation whose expression has text `a_expr'
			-- Void if no such equation is found.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
		do
			-- print ("item_with_expression_text: " + a_expr + "%N")
			l_cursor := new_cursor
			from
				l_cursor.start
			until
				l_cursor.after or Result /= Void
			loop
				if l_cursor.item.expression.text ~ a_expr then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

	item_with_expression (a_expr: EPA_EXPRESSION): detachable EPA_EQUATION
			-- Equation whose expression is `a_expr'
			-- Void if no such equation is found.
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
			l_equality_tester: FUNCTION [ANY, TUPLE [EPA_EXPRESSION, EPA_EXPRESSION], BOOLEAN]
		do
			l_equality_tester := agent expression_equality_tester.test
			l_cursor := new_cursor
			from
				l_cursor.start
			until
				l_cursor.after or Result /= Void
			loop
				if l_equality_tester.item ([l_cursor.item.expression, a_expr]) then
					Result := l_cursor.item
				end
				l_cursor.forth
			end
		end

	expressions_with_value (a_value: EPA_EXPRESSION_VALUE): EPA_HASH_SET [EPA_EXPRESSION]
		local
			l_cursor: DS_HASH_SET_CURSOR [EPA_EQUATION]
		do
			create Result.make_equal (count)
			from
				l_cursor := new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				if attached l_cursor.item.value.as_boolean as lt_boolean and then lt_boolean ~ a_value then
					Result.force (l_cursor.item.expression)
				end
				l_cursor.forth
			end
		end

	to_hash_table: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING]
			-- Hash table representation of Current
			-- Key is the text of the equations,
			-- value is the value associated in those equations.
		do
			create Result.make (count)
			Result.compare_objects
			do_all (
				agent (a_equation: EPA_EQUATION; a_table: HASH_TABLE [EPA_EXPRESSION_VALUE, STRING])
					do
						a_table.force (a_equation.value, a_equation.expression.text)
					end (?, Result))
		end

	only_predicates: like Current
			-- A subset of current which only contains equations of boolean type
		do
			Result := cloned_object
			Result.do_if (
				agent Result.remove,
				agent (a_equation: EPA_EQUATION): BOOLEAN
					do
						Result := not a_equation.expression.is_predicate
					end)
		end

	as_table: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]
			-- Current as a table
			-- Keys are the expessions in all the equations inside Current,
			-- values are the corresponding values of those equations.
		local
			l_cursor: DS_HASH_TABLE_CURSOR [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]
		do
			create Result.make (count)
			Result.set_key_equality_tester (expression_equality_tester)
			do_all (
				agent (a_tbl: DS_HASH_TABLE [EPA_EXPRESSION_VALUE, EPA_EXPRESSION]; a_equation: EPA_EQUATION)
					do
						a_tbl.force_last (a_equation.value, a_equation.expression)
					end (Result, ?))
		ensure
			good_result: Result.count = count
		end

	expressions: EPA_HASH_SET [EPA_EXPRESSION]
			-- Expressions of equations in Current
		do
			create Result.make (count)
			Result.set_equality_tester (expression_equality_tester)
			do_all (
				agent (a_equation: EPA_EQUATION; a_set: EPA_HASH_SET [EPA_EXPRESSION])
					do
						a_set.force_last (a_equation.expression)
					end (?, Result))
		end

feature -- Status report

	is_chaos: BOOLEAN
			-- Does this state stand for a chaos (the state before object creation)?

	is_delayed: BOOLEAN
			-- Is Current state delayed?
			-- Delayed state means that its actual values are to be instantiated
		do
		end

	has_expression (a_expression: EPA_EXPRESSION): BOOLEAN
			-- Is there an equation in Current with `a_expression' as its expression?
		do
			Result := attached item_with_expression (a_expression)
		end

feature -- Setting

    set_class (a_class: like class_)
		    -- set `class_' with `a_class'.
    	do
    		class_ := a_class
    	ensure
    		class_set: class_ = a_class
    	end

    keep_if (a_test: PREDICATE [ANY, TUPLE [equation: EPA_EQUATION]])
    		-- Keep equations only if they satisfy `a_test'.
    		-- Remove those equations which does not satisfy `a_test'.
    	local
    		l_list: LINKED_LIST [EPA_EQUATION]
    	do
			create l_list.make
			do_if (
				agent l_list.extend,
				agent (a_equ: EPA_EQUATION; t: PREDICATE [ANY, TUPLE [equation: EPA_EQUATION]]): BOOLEAN
					do
						Result := not t.item ([a_equ])
					end (?, a_test))

			l_list.do_all (agent remove)
    	end

feature -- Status report

	state_report (a_prefix: STRING): STRING
			-- Generate the string representation of current state.
			-- With 'a_prefix' preceding each line of the result.
		do
			create Result.make (512)
			do_all (
				agent (a_equation: EPA_EQUATION; a_string: STRING; a_pre: STRING)
					do
						a_string.append (a_pre)
						a_string.append (a_equation.debug_output)
						a_string.append_character ('%N')
					end (?, Result, a_prefix))
			Result.prune_all_trailing ('%N')
		end

	debug_output: STRING
			-- String that should be displayed in debugger to represent `Current'.
		do
			Result := state_report ("")
		end

	is_ce_state: BOOLEAN
			-- Is the current state derived from counterexample?

feature{NONE} -- Implementation

	key_to_hash: DS_LINEAR[INTEGER]
			-- <Precursor>
		local
		    l_list: DS_ARRAYED_LIST[INTEGER]
		do
		    create l_list.make (count)
			from start
			until after
			loop
			    l_list.force_last (item_for_iteration.hash_code)
				forth
			end

			Result := l_list
		end

	predicate_from_expression_and_value (a_expression: STRING; a_value: STRING; a_class: CLASS_C; a_feature: detachable FEATURE_I): EPA_EQUATION
			-- Predicate from `a_expression' and its `a_value'
		local
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
			l_written_class: CLASS_C
		do
			if a_feature /= Void then
				l_written_class := a_feature.written_class
			else
				l_written_class := a_class
			end

			if a_expression.same_string ("(Current).passed_blocks") then
				create l_expr.make_with_text_and_type (a_class, a_feature, safe_expr (a_expression), l_written_class, unknown_type)-- create {NATIVE_ARRAY_TYPE_A}.make (, create {ARRAYED_LIST [TYPE_A]}.make_from_array (<<create {INTEGER_A}.make (8)>>)))
			else
				create l_expr.make_with_text (a_class, a_feature, safe_expr (a_expression), l_written_class)
			end

			fixme ("Refactoring the following ugly if statement.")
			if a_value.tail (1).same_string (")") and not a_value.has ('(') then
				a_value.remove_tail (1)
			end

			if a_value = Void then
				create {EPA_VOID_VALUE} l_value.make
			else
				if a_value.is_boolean then
					create {EPA_BOOLEAN_VALUE} l_value.make (a_value.to_boolean)
				elseif a_value.is_integer_64 then
					create {EPA_INTEGER_VALUE} l_value.make (a_value.to_integer)
				elseif a_value.is_equal (nonsensical) then
					create {EPA_NONSENSICAL_VALUE} l_value
				elseif a_value.is_equal (void_value) then
					create {EPA_VOID_VALUE} l_value.make
				elseif a_value.starts_with (once "0x") then
					create {EPA_REFERENCE_VALUE} l_value.make (a_value.twin, l_expr.type)
				elseif a_value.starts_with (once "T@U!val!") then
					create {EPA_REFERENCE_VALUE} l_value.make (a_value.twin, l_expr.type)
				elseif a_value.starts_with (once "[") then
					create {EPA_ARRAY_VALUE} l_value.make (a_value.twin, l_expr.type)
				else
					check not_suported_not: False end
				end
			end
			create Result.make (l_expr, l_value)
			-- print ("epa_equation: " + l_expr.text + "-> " + l_value.out + "%N")
		end


	safe_expr (a_expr: STRING): STRING
			-- Remove prefix of Current's attributes
		do
			if not (a_expr.has_substring ("passed_blocks") or a_expr.has_substring ("sequence")) and a_expr.has_substring ("Current") and a_expr.has_substring (".") then
				Result := a_expr.split ('.').last
			else
				Result := a_expr
			end
		end

	derived_extra_equality
			-- When the source state is derived from a counterexample, derive new equalities realted to 'Void' and 'Current' based on the counterexample
			-- a = Void, a /= Void, a = Current, a /= Current
		local
			l_void_value, l_current_value: STRING
			l_expr: EPA_AST_EXPRESSION
			l_value: EPA_EXPRESSION_VALUE
		do
			l_void_value := item_with_expression_text ("Void").value.text
			l_current_value := item_with_expression_text ("Current").value.text

			from
				start
			until
				after
			loop
				if item_for_iteration.value.text.has_substring ("T@U") and item_for_iteration.text /~ "Current" and item_for_iteration.text /~ "Void" then
					if item_for_iteration.value.text ~ l_void_value then
						create {EPA_BOOLEAN_VALUE} l_value.make (true)
					else
						create {EPA_BOOLEAN_VALUE} l_value.make (false)
					end
					create l_expr.make_with_text (class_, feature_, item_for_iteration.expression.text + " = Void", class_)
					force_last (create {EPA_EQUATION}.make (l_expr, l_value))

					if item_for_iteration.value.text ~ l_current_value then
						create {EPA_BOOLEAN_VALUE} l_value.make (true)
					else
						create {EPA_BOOLEAN_VALUE} l_value.make (true)
					end
					create l_expr.make_with_text (class_, feature_, item_for_iteration.expression.text + " = Current", class_)
					force_last (create {EPA_EQUATION}.make (l_expr, l_value))
				end
				forth
			end
		end

end
