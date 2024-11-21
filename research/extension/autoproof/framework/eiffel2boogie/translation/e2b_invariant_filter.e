note
	description: "Options for filtering invariant clauses"

class
	E2B_INVARIANT_FILTER

create
	default_create

feature

	include_local: INTEGER assign set_include_local
			-- Accept local clauses?
			-- If `= 0` - don't check if local or not
			-- If `> 0` - must be local to match
			-- If `< 0` - must be not local to match
			--
			-- Clauses are local iff their computation depends only
			-- on the state of the object and not on the other objects
			--
			-- See `is_local` for details.

	set_include_local (x: INTEGER)
		do
			include_local := x
		end

	required_export_status: detachable EXPORT_I assign set_required_export_status

	set_required_export_status (export_status: detachable EXPORT_I)
		do
			required_export_status := export_status
		end

	is_matching (assert: ASSERT_B): BOOLEAN
			-- Is `assert` matching filters?
			--
			-- Assert matches by default but can be rejected with other filters
			-- like `include_local`.
		do
			Result := True
			if include_local /= 0 then
				Result := is_local (assert.expr) = (include_local > 0)
			end
			if Result and then attached required_export_status then
				Result := is_export_matching (assert.expr)
			end
		end

feature -- Public utilities

	export_status_less_or_equal (a, b: EXPORT_I): BOOLEAN
			-- True iff `a ⊆ b`.
		do
			if b.is_all then
				Result := True
			elseif a.is_none then
				Result := True
			elseif b.is_none then
					-- `a` is not none, so `b` is smaller
				Result := False
			elseif a.is_all then
					-- `b` can't be all here, so `a` is anyway greater
				Result := False
			else
				-- both `a` and `b` are sets
				check attached {EXPORT_SET_I} a as set_a
					and then attached {EXPORT_SET_I} b as set_b then
						-- `equiv` actually checks if target is subset of argument
					Result := set_a.first.equiv(set_b.first)
				end
			end
		end


feature {NONE}

	is_local (expr: EXPR_B): BOOLEAN
		-- Inner function to compute `is_local`
		do
			if expr = Void then
				Result := True -- Missing instruction in local
			elseif attached {NESTED_B} expr then
				Result := False
			elseif attached {CONSTANT_B} expr then
				Result := True
			elseif attached {BOOL_CONST_B} expr then
				Result := True
			elseif attached {BINARY_B} expr as binary then
				Result := is_local (binary.left) and then is_local (binary.right)
			elseif attached {UNARY_B} expr as unary then
				Result := is_local (unary.expr) and then is_local (unary.access)
			elseif attached {ATTRIBUTE_B} expr then
				Result := True
			elseif attached {INTEGER_CONSTANT} expr then
				Result := True
			elseif attached {VOID_B} expr then
				Result := True
			elseif attached {CURRENT_B} expr then
				Result := True
			elseif attached {LOOP_EXPR_B} expr as loop_expr then
				if is_local (loop_expr.expression_code) then
					{EXCEPTIONS}.raise (
						"Expression in loop is local. Don't know how to check other fields.")
				end
				Result := False
			elseif attached {ROUTINE_B} expr as attr then
					-- We don't analyze features for now,
					-- so be safe and assume they can have remote calls
				Result := False
			else
				{EXCEPTIONS}.raise ("Unknown node " + expr.out)
			end
		end

	is_export_matching (expr: BYTE_NODE): BOOLEAN
		do
			if required_export_status.is_all then
				Result := True -- ANY will match all clauses anyway
			elseif expr = Void then
				Result := True -- Assume missing instruction is matching
			elseif attached {NESTED_B} expr as nested then
				if attached {CALL_ACCESS_B} nested.target as call then
					Result := is_call_export_matching (call)
				elseif attached {ACCESS_EXPR_B} nested.target as access_expr then
					if attached {NESTED_B} access_expr.expr as expr_nested then
						-- This is (a.b) of (a.b.c). We care only about the `a`
						Result := is_export_matching (expr_nested)
					end
				else
					{EXCEPTIONS}.raise ("Unknown nested target: " + nested.target.out)
				end
			elseif attached {ATTRIBUTE_B} expr as attr then
				Result := is_call_export_matching (attr)
			elseif attached {BINARY_B} expr as bin then
				Result := is_export_matching (bin.left) and then is_export_matching (bin.right)
			elseif attached {EXTERNAL_B} expr as ext then
				-- Target of the call is in `ext.parent`
				-- We assume that we already visited it before in an earlier recursive call
				Result := ∀ p: ext.parameters ¦ is_export_matching (p.expression)
			elseif attached {CURRENT_B} expr then
				Result := True -- Current does not affect visibility, so assume it always matches
			elseif attached {LOOP_EXPR_B} expr as loop_expr then
				Result := ∀ it: loop_expr.iteration_code ¦ is_export_matching (it)
					and then is_export_matching (loop_expr.advance_code)
					and then is_export_matching (loop_expr.iteration_exit_condition_code)
					and then is_export_matching (loop_expr.exit_condition_code)
					and then is_export_matching (loop_expr.expression_code)
			elseif attached {ASSIGN_B} expr as assgn then
				Result := is_export_matching (assgn.target)
					and then is_export_matching (assgn.source)
			elseif attached {OBJECT_TEST_LOCAL_B} expr then
					-- local variable is not relevant for feature visibility
				Result := True
			else
				{EXCEPTIONS}.raise ("Unknown node in export matching: " + expr.out)
			end
		end

	is_call_export_matching (call: CALL_ACCESS_B): BOOLEAN
			-- Does the call match `required_export_status`?
			-- Yes iff call's feature has visibility ⊆ `required_export_status`
		local
			call_export: EXPORT_I
		do
			call_export := call.System
				.class_of_id (call.written_in)
				.feature_of_feature_id (call.feature_id)
				.export_status

			Result := export_status_less_or_equal (call_export, required_export_status)
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
