note
	description: "Node in a circular doubly-linked list."
	explicit: "all"

frozen class F_DLL_NODE_D

create
	make

feature {NONE} -- Initialization

	make
			-- Create a singleton node.
		note
			status: creator
		do
			left := Current
			right := Current
			set_subjects (create {MML_SET [ANY]} & left & right)
			set_observers (create {MML_SET [ANY]} & left & right)
			wrap
		ensure
			modify (Current)
			singleton: left = Current
			default_wrapped: is_wrapped
		end

feature -- Access

	left: F_DLL_NODE_D
			-- Left neighbor.
		note
			guard: not_left
		attribute
		end

	right: F_DLL_NODE_D
			-- Right neighbor.			
		note
			guard: not_right
		attribute
		end

feature -- Modification

	insert_right (n: F_DLL_NODE_D)
			-- Insert node `n' to the right of the current node.
		require
			n_exists: n /= Void
			n_singleton: n.left = n
			default_wrapped: is_wrapped
			default_arg_wrapped: n.is_wrapped
			default_observers_wrapped: across observers as o all o.is_wrapped end
		local
			r: F_DLL_NODE_D
		do
			r := right
			unwrap_all (create {MML_SET [ANY]} & Current & r & n)

			n.set_right (r)
			n.set_left (Current)

			r.set_left (n)
			set_right (n)

			n.set_subjects (create {MML_SET [ANY]} & r & Current)
			n.set_observers (create {MML_SET [ANY]} & r & Current)
			set_subjects (create {MML_SET [ANY]} & left & n)
			set_observers (create {MML_SET [ANY]} & left & n)
			r.set_subjects (create {MML_SET [ANY]} & n & r.right)
			r.set_observers (create {MML_SET [ANY]} & n & r.right)
			wrap_all (create {MML_SET [ANY]} & Current & r & n)
		ensure
			modify (Current, right, n)
			n_left_set: right = n
			n_right_set: n.right = old right
			default_wrapped: is_wrapped
			default_arg_wrapped: n.is_wrapped
			default_observers_wrapped: across observers as o all o.is_wrapped  end
		end

	remove
			-- Remove the current node from the list.
    require
			default_wrapped: is_wrapped
			default_observers_wrapped: across observers as o all o.is_wrapped  end
		local
			l, r: F_DLL_NODE_D
		do
			l := left
			r := right
			unwrap_all (create {MML_SET [ANY]} & Current & l & r)

			set_left (Current)
			set_right (Current)

			l.set_right (r)
			r.set_left (l)

			set_subjects (create {MML_SET [ANY]} & Current)
			set_observers (create {MML_SET [ANY]} & Current)
			l.set_subjects (create {MML_SET [ANY]} & l.left & r)
			l.set_observers (create {MML_SET [ANY]} & l.left & r)
			r.set_subjects (create {MML_SET [ANY]} & l & r.right)
			r.set_observers (create {MML_SET [ANY]} & l & r.right)
			wrap_all (create {MML_SET [ANY]} & Current & l & r)
		ensure
			modify (Current, left, right)
			singleton: right = Current
			old_left_wrapped: (old left).is_wrapped
			old_right_wrapped: (old right).is_wrapped
			neighbors_connected: (old left).right = old right
			default_wrapped: is_wrapped
			default_observers_wrapped: across observers as o all o.is_wrapped  end
		end

feature {F_DLL_NODE_D} -- Implementation

	set_left (n: F_DLL_NODE_D)
			-- Set left neighbor to `n'.
		require
			open: is_open
			left_open: left.is_open
		do
			left := n -- preserves `right'
		ensure
			modify_field ("left", Current)
			left = n
		end

	set_right (n: F_DLL_NODE_D)
			-- Set right neighbor to `n'.
		require
			open: is_open
			right_open: right.is_open
		do
			right := n -- preserves `left'
		ensure
			modify_field ("right", Current)
			right = n
		end

feature -- Specification

	not_left (new_left: F_DLL_NODE_D; o: ANY): BOOLEAN
			-- Is `o' different from `left'?
		note
			status: functional
		do
			Result := o /= left
		end

	not_right (new_right: F_DLL_NODE_D; o: ANY): BOOLEAN
			-- Is `o' different from `right'?
		note
			status: functional
		do
			Result := o /= right
		end

invariant
	left_exists: left /= Void
	right_exists: right /= Void
	subjects_structure: subjects = create {MML_SET [ANY]} & left & right
	observers_structure: observers = create {MML_SET [ANY]} & left & right
	left_consistent: left.right = Current
	right_consistent: right.left = Current
	subjects_aware: left.observers [Current] and right.observers [Current]
	default_owns: owns = create {MML_SET [ANY]}

note
	date: "$Date$"
	revision: "$Revision$"
	copyright:
		"Copyright (c) 2013-2014 ETH Zurich",
		"Copyright (c) 2018 Politecnico di Milano",
		"Copyright (c) 2022 Schaffhausen Institute of Technology"
	author: "Julian Tschannen", "Nadia Polikarpova", "Alexander Kogtenkov"
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
