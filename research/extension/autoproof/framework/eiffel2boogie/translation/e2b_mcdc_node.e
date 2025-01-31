note
	description: "Summary description for {E2B_MCDC_NODE}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_MCDC_NODE

create make

feature {NONE} -- Initialization

	make (a_operator: STRING; a_left, a_right: detachable E2B_MCDC_NODE)
		-- Instantiate a node with its parent, left and right child
	do
			operator := a_operator
			left := a_left
			right := a_right
	end

feature -- Access

	parent: detachable E2B_MCDC_NODE
		-- Parent of the current node if any

	sibling: detachable E2B_MCDC_NODE
		-- Sibling of the current node if any

	left: detachable E2B_MCDC_NODE
		-- Left child of the current node if any

	right: detachable E2B_MCDC_NODE
		-- Right child of the current node if any

	operator: STRING
		-- Operator of the current node

	expected_value: BOOLEAN
		-- Value of the current node when traversing for MCDC

	value: STRING
		-- Value of boolean constant

feature -- Status

	has_parent: BOOLEAN
			-- Does the current node have any parent?

	is_leaf: BOOLEAN
		    -- Is the current node a leaf node?
		  do
		  		Result := not (attached left or attached right)
		  end

	-- value: BOOLEAN
	--		-- Value of the subtree rooted by the current node; False by default

feature -- Setting procedures

	set_parent (a_parent: E2B_MCDC_NODE)
		-- Set `parent' to `a_parent'
	do
		parent := a_parent
	end

	set_sibling (a_sibling: E2B_MCDC_NODE)
		-- Set `parent' to `a_parent'
	do
		sibling := a_sibling
	end

	set_expected_value (a_value: BOOLEAN)
		-- Set `expected_value' to `a_value'  if the current node is a leaf node;
		-- otherewise, set the values of the leaf nodes of the tree rooted by the current node;
		-- the value of the leafs should make the current node evaluated as `a_value'
	do
		if is_leaf then
			expected_value := a_value
		else
		    if operator ~ "&&" or operator ~ "||" then
		   		left.set_expected_value (a_value)
		   		right.set_expected_value (a_value)
		   	elseif operator ~ "==>" or  operator ~ "=="  then
		   		left.set_expected_value (True)
		   		right.set_expected_value (a_value)
		     elseif operator ~ "!=" then
		   		left.set_expected_value (False)
		   		right.set_expected_value (a_value)
		   	elseif operator ~ "!" then
		   		left.set_expected_value (not a_value)
		    end
		end
	end

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
