note
	description: "[
		Examples from the paper
		"The concept of class invariant in object-oriented programming"
		by Bertrand Meyer, Alisa Arkadova, Alexander Kogtenkov
	]"
	testing: "type/manual"
	testing: "autoproof"
	testing: "execution/isolated"

class AP_INVARIANT_SLICING_EXAMPLES

inherit
	AP_TEST_EXAMPLES

feature -- Testing

	marriage
		do
			print_file ("person.e", "[
				class
					PERSON
				create
					make
				feature
					make
						do
						end
					spouse: PERSON

					is_married: BOOLEAN

					marry (o: PERSON)
							-- Marry current person to `o`.
						require
							pre1: o /= Current
							pre2: not is_married
							pre3: not o.is_married
						do
							set_spouse (o)
							set_married
							o.set_spouse (Current)
							o.set_married
						ensure
							modify_field (["spouse", "is_married"], [Current, o])
							post1: o.spouse = Current
							post2: spouse = o
						end

					divorce (o: PERSON)
							-- Remove marriage link with `o`.
						require
							pre1: is_married
							pre2: spouse.is_married
							pre3: o = spouse
						do
							o.unset_married
							unset_married
							o.unset_spouse
							unset_spouse
						ensure
							modify_field (["spouse", "is_married"], [Current, o])
							post1: not is_married
							post2: not (old spouse).is_married
						end

				feature {PERSON}
					set_married
						do
							is_married := True
						ensure
							modify_field (["is_married"], Current)
							post1: is_married
						end

					unset_married
						do
							is_married := False
						ensure
							modify_field (["is_married"], Current)
							post1: not is_married
						end

					set_spouse (o: PERSON)
							-- Make `o` the spouse of current person.
						require
							pre1: o /= Current
							pre2: not o.is_married implies (o.spouse = Void)
							pre3: o.is_married implies (o.spouse = Current)
						do
							spouse := o
						ensure
							modify_field (["spouse"], Current)
							post1: spouse = o
						end

					unset_spouse
						do
							spouse := Void
						ensure
							modify_field (["spouse"], Current)
							post1: spouse = Void
						end

				invariant
					inv1: spouse /= Current
					inv2: is_married = (spouse /= Void)
					inv3: is_married implies (spouse.spouse = Current)
				end
			]")
			is_void_safe := False
			print_ecf ("PERSON")

			command.add_class ("PERSON")

			verify
		end

	circular_double_linked_list
		do
			print_file ("circular_node.e", "[
				class
					CIRCULAR_NODE [G]

				create
					make

				feature {CIRCULAR_NODE}
					make (v: G)
							-- Initialize with single node of value `v`.
						do
							value := v
							left := Current
							right := Current
						ensure
							modify_field (["value", "left", "right"], Current)
							post1: value = v
							post2: left = Current
							post3: right = Current
						end

					set_right (o: CIRCULAR_NODE [G])
							-- Add `o` as right neighbor.
						require
pre_fix1: o /= Current
							pre1: o.left.right = o
							pre2: o.right.left = o
						do
							right := o
						ensure
							modify_field (["right"], Current)
							post1: right = o
						end

					set_left (o: CIRCULAR_NODE [G])
							-- Add `o` as left neighbor.
						require
pre_fix1: o /= Current
							pre1: o.left.right = o
							pre2: o.right.left = o
						do
							left := o
						ensure
							modify_field (["left"], Current)
							post1: left = o
						end

					insert_between_two (v: G; l, r: CIRCULAR_NODE [G])
							-- Add node of value `v` between `l` and `r`.
						require
pre_fix2: l /= Current
pre_fix2: r /= Current
							pre1: l.right = r
							pre2: r.left = l
						do
							make (v)
							l.set_right (Current)
							r.set_left (Current)
							left := l
							right := r
						ensure
							modify_field (["value", "left", "right"], Current)
							modify_field (["right"], l)
							modify_field (["left"], r)
							post1: value = v
							post2: left = l
							post3: right = r
						end

				feature
					value: G

					left, right: CIRCULAR_NODE [G]

					remove (l: CIRCULAR_NODE [G])
							-- Delete `l` from its list.
						require
							pre1: l = left
							pre2: l.left.left.right = l.left
							pre3: l.left.right.left = l.left
							pre4: right.left.right = right
							pre5: right.right.left = right
						do
							if l = right then
								l.make (value)
							else
								l.insert_between_two (l.value, l.left, right)
							end
							make (value)
						ensure
							modify_field (["value", "left", "right"], [Current, l])
							post1: left = Current
							post2: (old left).right = old right
						end

					insert_right (v: G; l: CIRCULAR_NODE [G])
							-- Insert node of value `v` on the right of `l`
						do
							insert_between_two (v, l, l.right)
						end

				invariant
					inv1: left.right = Current
					inv2: right.left = Current
				end
			]")
			print_file ("application.e", "[
				class
					APPLICATION
				create
					make
				feature
					make
						local
							a: CIRCULAR_NODE [INTEGER]
						do
						end
				end
			]")
			print_ecf ("APPLICATION")
			command.add_class ("CIRCULAR_NODE")

			verify
		end

	counterexample_1_test
		do
			print_file ("c.e", "[
				class
					C
				create
					make
				feature
					a: INTEGER
					make
						local
							d: D
						do
							a := 1
						end

					test
						do
							check c1: a > 0 end
						ensure
							modify ([])
						end
				feature {D}
					set_a (x: INTEGER)
						do
							a := x
						ensure
							a = x
							modify_field ("a", Current)
						end

				invariant
					inv1: a > 0
				end
			]")
			print_file ("d.e", "[
				class
					D
				feature
					break (c: C)
						require
							c /= Void
						do
							c.set_a (-10)
							c.test
							c.set_a (100)
						ensure
							modify_field ("a", c)
						end
				end
			]")
			print_ecf ("C")

			command.add_class ("C")
			command.add_class ("D")

			verify
		end
end
