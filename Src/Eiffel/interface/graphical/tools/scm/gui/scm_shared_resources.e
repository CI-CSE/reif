note
	description: "Summary description for {SCM_SHARED_RESOURCES}."
	date: "$Date$"
	revision: "$Revision$"

deferred class
	SCM_SHARED_RESOURCES

inherit
	EB_SHARED_PIXMAPS

	SHARED_SCM_NAMES

feature -- Access	

	stock_colors: EV_STOCK_COLORS
		once
			create Result
		end

	status_pixmap (a_status: SCM_STATUS): detachable EV_PIXMAP
		do
			if attached {SCM_STATUS_MODIFIED} a_status then
				Result := icon_pixmaps.source_modified_icon
			elseif attached {SCM_STATUS_ADDED} a_status then
				Result := icon_pixmaps.source_added_icon
			elseif attached {SCM_STATUS_DELETED} a_status then
				Result := icon_pixmaps.source_deleted_icon
			elseif attached {SCM_STATUS_CONFLICTED} a_status then
				Result := icon_pixmaps.source_conflicted_icon
			elseif attached {SCM_STATUS_UNVERSIONED} a_status then
				Result := icon_pixmaps.source_unversioned_icon
			else
			end
		end

invariant
note
	copyright: "Copyright (c) 1984-2021, Eiffel Software"
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
