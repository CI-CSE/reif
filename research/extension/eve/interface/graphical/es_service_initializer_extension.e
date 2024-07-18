note
	description: "An extension to initialize more services in addiion to standard services of EiffelStudio."
	legal: "See notice at end of class."
	status: "See notice at end of class.";
	date: "$Date$";
	revision: "$Revision$"

class
	ES_SERVICE_INITIALIZER_EXTENSION

inherit
	ES_SERVICE_INITIALIZER
		redefine
			add_core_services
		end

	SERVICE_INITIALIZER_EXTENSION
		undefine
			new_debugger_service,
			new_environment_service,
			new_output_manager_service,
			new_rota_service,
			register_environment_variables,
			register_outputs
		redefine
			add_core_services
		end

feature -- Services

	add_core_services (c: SERVICE_CONTAINER_S)
			-- <Precursor>
		do
			Precursor {ES_SERVICE_INITIALIZER} (c)
			Precursor {SERVICE_INITIALIZER_EXTENSION} (c)

			-- AutoProof
			c.register_with_activator ({VERIFIER_S}, agent new_verifier_service, False)

			-- EVE or Common
			c.register_with_activator ({CONTEXT_MENU_EXTENSION_S}, agent new_context_menu_extension_service, False)
			c.register_with_activator ({TOOL_MENU_EXTENSION_S}, agent new_tool_menu_extension_service, False)
			c.register_with_activator ({BLACKBOARD_S}, agent new_blackboard_service, False)
		end

feature {NONE} -- Factory

	new_verifier_service: VERIFIER_S
			-- New verifier service.
		do
			create {ES_AUTOPROOF_VERIFIER} Result
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_context_menu_extension_service: CONTEXT_MENU_EXTENSION_S
			-- New context menu extension service.
		do
			create {ES_CONTEXT_MENU_EXTENSION} Result
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_tool_menu_extension_service: TOOL_MENU_EXTENSION_S
			-- New tool menu extension service.
		do
			create {ES_TOOL_MENU_EXTENSION} Result
		ensure
			is_interface_usable: attached Result implies Result.is_interface_usable
		end

	new_blackboard_service: detachable BLACKBOARD_S
			-- Create blackboard service.
		local
			l_cluster_observer: ES_BLACKBOARD_CLUSTER_OBSERVER
		do
			create {EBB_BLACKBOARD} Result.make
			if Result.is_interface_usable then
				Result.register_tool (create {E2B_TOOL})
				Result.register_tool (create {EBB_AUTOTEST_TOOL})
				Result.register_tool (create {EBB_CA_TOOL})
				create l_cluster_observer
				l_cluster_observer.manager.extend (l_cluster_observer)
			end
		end

note
	date: "$Date$";
	revision: "$Revision$"
	copyright:
		"Copyright (c) 2018 Politecnico di Milano",
		"Copyright (c) 2021-2022 Schaffhausen Institute of Technology"
	author: "Alexander Kogtenkov"
	license: "GNU General Public License v2.0 or later"
	license_name: "GPL-2.0-or-later"
	EIS: "name=GPL-2.0", "src=https://www.gnu.org/licenses/gpl-2.0.html", "tag=license"
	copying: "[
		This program is free software; you can redistribute it and/or modify it under the terms of
		the GNU General Public License as published by the Free Software Foundation; either version 2 
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY;
		without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
		See the GNU General Public License for more details.

		You should have received a copy of the GNU General Public License along with this program.
		If not, see <https://www.gnu.org/licenses/>.
	]"

end
