note
<<<<<<<< HEAD:Src/Eiffel/interface/graphical/tools/code_analysis/utilities/es_ca_preferences_dialog.e
	description: "Preferences dialog for Code Analysis."
	legal: "See notice at end of class."
	status: "See notice at end of class."
========
	description: "Summary description for {IRON_NODE_CONSTANTS}."
	author: ""
>>>>>>>> a8ab064a286ce1f37c8d195726363d5bbe4fe111:Src/tools/iron/server/kernel/iron_node_constants.e
	date: "$Date$"
	revision: "$Revision$"

class
<<<<<<<< HEAD:Src/Eiffel/interface/graphical/tools/code_analysis/utilities/es_ca_preferences_dialog.e
	ES_CA_PREFERENCES_DIALOG

inherit
	EV_DIALOG

create
	make

feature {NONE} -- Initialization

	make
		do
			build_interface
		end

	build_interface
		do

		end
========
	IRON_NODE_CONSTANTS

feature -- Access

	major: INTEGER = 0
	minor: INTEGER = 1
	built: STRING = "0007"

	version: STRING
		do
			Result := major.out + "." + minor.out + "." + built
		end

feature -- Access

	iron_repo_variable_name: STRING = "IRON_REPO"
>>>>>>>> a8ab064a286ce1f37c8d195726363d5bbe4fe111:Src/tools/iron/server/kernel/iron_node_constants.e

feature {NONE} -- Implementation



note
	copyright: "Copyright (c) 1984-2013, Eiffel Software"
	license: "GPL version 2 (see http://www.eiffel.com/licensing/gpl.txt)"
	licensing_options: "http://www.eiffel.com/licensing"
	copying: "[
			This file is part of Eiffel Software's Eiffel Development Environment.
			
			Eiffel Software's Eiffel Development Environment is free
			software; you can redistribute it and/or modify it under
			the terms of the GNU General Public License as published
			by the Free Software Foundation, version 2 of the License
			(available at the URL listed under "license" above).
			
			Eiffel Software's Eiffel Development Environment is
			distributed in the hope that it will be useful, but
			WITHOUT ANY WARRANTY; without even the implied warranty
			of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
			See the GNU General Public License for more details.
			
			You should have received a copy of the GNU General Public
			License along with Eiffel Software's Eiffel Development
			Environment; if not, write to the Free Software Foundation,
			Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA
		]"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"
end
