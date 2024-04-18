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
			elseif attached {ATTRIBUTE_B} expr then
				Result := True
			elseif attached {INTEGER_CONSTANT} expr then
				Result := True
			elseif attached {VOID_B} expr then
				Result := True
			elseif attached {CURRENT_B} expr then
				Result := True
			elseif attached {ROUTINE_B} expr as attr then
					-- We don't analyze features for now,
					-- so be safe and assume they can have remote calls
				Result := False
			else
				{EXCEPTIONS}.raise ("Unknown node " + expr.out)
			end
		end

	is_export_matching (expr: EXPR_B): BOOLEAN
		do
			if required_export_status.is_all then
				Result := True -- ANY will match all clauses anyway
			elseif expr = Void then
				Result := True -- Assume missing instruction is matching
			elseif attached {NESTED_B} expr as nested then
				if attached {CALL_ACCESS_B} nested.target as call then
					Result := is_call_export_matching (call)
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

			if call_export.is_all then
				Result := required_export_status.is_all
			elseif call_export.is_none then
				Result := True
			elseif required_export_status.is_none then
					-- `call_export` is not none,
					-- so `required_export_status` none is smaller than `call_export`
					-- so it doesn't match
				Result := False
			else
				check attached {EXPORT_SET_I} call_export as set
					and then attached {EXPORT_SET_I} required_export_status as required_set then
						-- `equiv` actually checks if target is subset of arg
					Result := set.first.equiv(required_set.first)
				end
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
