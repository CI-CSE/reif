note
	description: "Summary description for {PROOF2TEST_TARGET_FEATURE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_PROOF_TO_TEST_TARGET_FEATURE

create
    make

feature {NONE} -- Initialize
    make (a_target_feature: E2B_FEATURE_I; a_target_class: E2B_CLASS_C)
       -- Initialize
    do
    	target_feature := a_target_feature
    	target_class := a_target_class
    	create creation_procedures.make
    end

feature -- Data

    target_feature: E2B_FEATURE_I
        -- Feature to under verification

    target_class: E2B_CLASS_C
        -- Class of the target feature

    creation_procedures: LINKED_LIST[FEATURE_I]
        -- List of creation procedures of the target class
;note
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

