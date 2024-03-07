note
	description: "[
		TODO
	]"
	date: "$Date$"
	revision: "$Revision$"

deferred class
	E2B_CUSTOM_CALL_HANDLER

inherit

	E2B_SHARED_CONTEXT
		export {NONE} all end

	IV_SHARED_TYPES

	IV_SHARED_FACTORY

	INTERNAL_COMPILER_STRING_EXPORTER

feature -- Status report

	is_handling_call (a_target_type: E2B_TYPE_A; a_feature: E2B_FEATURE_I): BOOLEAN
			-- Is this handler handling the call?
		deferred
		end

feature -- Basic operations

	handle_routine_call_in_body (a_translator: E2B_BODY_EXPRESSION_TRANSLATOR; a_feature: E2B_FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Handle routine call in body.
		deferred
		end

	handle_routine_call_in_contract (a_translator: E2B_CONTRACT_EXPRESSION_TRANSLATOR; a_feature: E2B_FEATURE_I; a_parameters: BYTE_LIST [PARAMETER_B])
			-- Handle routine call in contract.
		deferred
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
