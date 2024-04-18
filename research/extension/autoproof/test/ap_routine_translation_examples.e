note
	description: "[
		Tests for routine Eiffel to Boogie translation:

		pre-/post- conditions, qualified/unqualified calls
	]"
	testing: "type/manual"
	testing: "autoproof"
	testing: "execution/isolated"

class
	AP_ROUTINE_TRANSLATION_EXAMPLES

inherit
	AP_TEST_EXAMPLES

feature -- Testing
	translate_un_and_qualified_versions
		local
			qualified, unqualified: IV_PROCEDURE
		do
			print_file ("demo.e", "[
				class
					DEMO

				create
					make

				feature

				make
					do
					end

				test
					require
						normal_pre: True
					do
					ensure
						normal_post: True
					end

				invariant
					inv: 1 = 1
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			qualified := procedure_by_name ("qualified.DEMO.test")
			assert_attached ("Has qualified version", qualified)
			assert ("Qualified has normal precondition", attached contract_by_tag ("normal_pre", qualified))
			assert ("Qualified has normal postcondition", attached contract_by_tag ("normal_post", qualified))
			assert ("Qualified has free inv precondition",
				attached {IV_PRECONDITION} contract_by_type ("inv_pre", qualified) as x and then x.is_free
			)
			assert ("Qualified has inv postcondition", attached contract_by_type ("inv_post", qualified))

			unqualified := procedure_by_name ("unqualified.DEMO.test")
			assert_attached ("Has unqualified version", unqualified)
			assert ("Unqualified has normal precondition", attached contract_by_tag ("normal_pre", unqualified))
			assert ("Unqualified has normal postcondition", attached contract_by_tag ("normal_post", unqualified))
			assert ("Unqualified has no inv pre-/post-condition", not attached contract_by_tag ("inv", unqualified))
		end

	translate_qual_unqual_calls
		local
			qual, unqual, current_qual: LINKED_LIST [IV_STATEMENT]
		do
			print_file ("demo.e", "[
				class
					DEMO

				create
					make

				feature
					make
						do
						end

					qual (x: DEMO)
						do
							x.make
						end

					current_qual
						do
							Current.make
						end

					unqual
						do
							make
						end

				invariant
					inv: 1 = 1
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("qual", "DEMO")
			command.add_feature ("current_qual", "DEMO")
			command.add_feature ("unqual", "DEMO")

			verify

			qual := implementation_by_procedure_name ("unqualified.DEMO.qual")
				.body
				.statements

			assert ("Qualified call checks own invariant", ∃ s: qual ¦
				attached {IV_ASSERT} s as c and then attached c.node_info as i and then i.tag ~ "inv"
			)

			assert ("Qualified call calls qualified Boogie variant", ∃ s: qual ¦
				attached {IV_PROCEDURE_CALL} s as c and then c.name ~ "qualified.DEMO.make"
			)

			current_qual := implementation_by_procedure_name ("unqualified.DEMO.current_qual")
				.body
				.statements

			assert ("Qualified call to Current checks own invariant", ∃ s: current_qual ¦
				attached {IV_ASSERT} s as c and then attached c.node_info as i and then i.tag ~ "inv"
			)

			assert ("Qualified call to Current calls qualified Boogie variant", ∃ s: current_qual ¦
				attached {IV_PROCEDURE_CALL} s as c and then c.name ~ "qualified.DEMO.make"
			)

			unqual := implementation_by_procedure_name ("unqualified.DEMO.unqual")
				.body
				.statements

			assert ("Unqualified call does not check own invariant", not ∃ s: unqual ¦
				attached {IV_ASSERT} s as c and then attached c.node_info as i and then i.tag ~ "inv"
			)

			assert ("Unqualified call calls unqualified Boogie variant", ∃ s: unqual ¦
				attached {IV_PROCEDURE_CALL} s as c and then c.name ~ "unqualified.DEMO.make"
			)
		end

	qual_call_checks_sliced_invariant
		local
			tags: ARRAY [STRING]
		do
			print_file ("demo.e", "[
				class
					DEMO

				create
					make

				feature
					make
						do
							Current.demo
						end

				for_all: BOOLEAN

				feature {DEMO, A, B, C}
					demo
						do
						end

					demo_abc: BOOLEAN

				feature {A} a: BOOLEAN

				feature {A, B} ab: BOOLEAN

				feature {C, D} cd: BOOLEAN

				feature {D} d: BOOLEAN

				feature {NONE} for_none: BOOLEAN

				invariant
					for_all: for_all
					demo_abc: demo_abc
					a: a
					ab: ab
					cd: cd
					d: d
					for_none: for_none
				end
			]")
			print_file ("a.e", "class A end")
			print_file ("b.e", "class B end")
			print_file ("c.e", "class C end")
			print_file ("d.e", "class D end")
			print_ecf ("DEMO")
			command.add_feature ("make", "DEMO")

			verify

			create tags.make_empty
			across
				implementation_by_procedure_name ("unqualified.DEMO.make").body.statements
					as statement
			loop
				if attached {IV_ASSERT} statement as a and then attached a.node_info.tag as t then
					tags.force (t, tags.count + 1)
				end
			end

			assert_arrays_equal ("Only visible to {DEMO, A, B, C, NONE} invariant checked",
				<< "demo_abc", "a", "ab", "for_none" >>,
				tags
			)
		end

	qualified_pre_post_invariant_slicing
		local
			tags: like inv_pre_post_contract_tags
		do
			print_file ("demo.e", "[
				class
					DEMO

				create
					make

				feature
					make do end

					test_all do end
					for_all: BOOLEAN
					for_all_ref: DEMO

				feature {A}
					test_a do end
					for_a: BOOLEAN
					for_a_ref: DEMO

				feature {DEMO}
					test_demo do end
					for_demo: BOOLEAN
					for_demo_ref: DEMO

				feature {NONE}
					test_none do end
					for_none: BOOLEAN
					for_none_ref: DEMO

				invariant
					for_all: for_all
					for_all_ref: for_all_ref.for_demo
					for_a: for_a
					for_a_ref: for_a_ref.for_all
					for_none: for_none
					for_none_ref: for_none_ref.for_all
					for_a_none: for_a and for_none
					for_a_all: for_a and for_all
					end
			]")
			print_file ("a.e", "class A end")
			print_ecf ("DEMO")
			command.add_feature ("test_all", "DEMO")
			command.add_feature ("test_a", "DEMO")
			command.add_feature ("test_demo", "DEMO")
			command.add_feature ("test_none", "DEMO")

			verify

			tags := inv_pre_post_contract_tags ("qualified.DEMO.test_all")
			assert_arrays_equal ("Export to all, only local inv clauses are in precondition",
				<< "for_all", "for_a", "for_none", "for_a_none", "for_a_all" >>,
				tags.pre
			)
			assert_arrays_equal ("Export to all, all inv clauses are in postcondition",
				<< "for_all", "for_all_ref", "for_a", "for_a_ref", "for_none", "for_none_ref",
					"for_a_none", "for_a_all" >>,
				tags.post
			)

			tags := inv_pre_post_contract_tags ("qualified.DEMO.test_a")
			assert_arrays_equal ("Export to A, only local {NONE, A} are in precondition",
				<< "for_a", "for_none", "for_a_none" >>,
				tags.pre
			)
			assert_arrays_equal ("Export to A, all {NONE, A} are in postcondition",
				<< "for_a", "for_a_ref", "for_none", "for_none_ref", "for_a_none" >>,
				tags.post
			)

			tags := inv_pre_post_contract_tags ("qualified.DEMO.test_demo")
			assert_arrays_equal ("Export to DEMO, only local {NONE, DEMO} are in precondition",
				<< "for_none" >>,
				tags.pre
			)
			assert_arrays_equal ("Export to DEMO, all {NONE, DEMO} are in postcondition",
				<< "for_none", "for_none_ref" >>,
				tags.post
			)

			tags := inv_pre_post_contract_tags ("qualified.DEMO.test_none")
			assert_arrays_equal ("Export to NONE, only local {NONE} are in precondition",
				<< "for_none" >>,
				tags.pre
			)
			assert_arrays_equal ("Export to NONE, all {NONE} are in postcondition",
				<< "for_none", "for_none_ref" >>,
				tags.post
			)
		end

	translate_arguments
		local
			qualified, unqualified: IV_PROCEDURE
		do
			print_file ("demo.e", "[
				class
					DEMO

				create
					make

				feature
					make
						do
						end

					demo_ok: BOOLEAN
						do
							Result := True
						end

					test (demo: DEMO; other: OTHER)
						do
						end

				invariant
					demo_inv: demo_ok
				end
			]")
			print_file ("other.e", "[
				class
					OTHER

				feature

				other_ok: BOOLEAN
					do
						Result := True
					end

				invariant
					other_inv: other_ok
				end
			]")
			print_ecf ("DEMO")
			command.add_feature ("test", "DEMO")

			verify

			qualified := procedure_by_name ("qualified.DEMO.test")
			assert_attached ("Has qualified version", qualified)
			assert ("Qualified has invariant of `demo` as precondition",
				attached contract_by_tag_and_type ("demo_inv", "arg_inv_pre", qualified)
			)
			assert ("Qualified has invariant of `demo` as postcondition",
				attached contract_by_tag_and_type ("demo_inv", "arg_inv_post", qualified)
			)
			assert ("Qualified has invariant of `other` as precondition",
				attached contract_by_tag_and_type ("other_inv", "arg_inv_pre", qualified)
			)
			assert ("Qualified has invariant of `other` as postcondition",
				attached contract_by_tag_and_type ("other_inv", "arg_inv_post", qualified)
			)

			unqualified := procedure_by_name ("unqualified.DEMO.test")
			assert ("Unqualified has no argument invariants as precondition",
				not attached contract_by_tag ("arg_inv_pre", unqualified)
			)
			assert ("Unqualified has no argument invariants as postcondition",
				not attached contract_by_tag ("arg_inv_post", unqualified)
			)
		end


feature {NONE}
	contract_by_tag (tag: STRING; procedure: IV_PROCEDURE): detachable IV_CONTRACT
		do
			across procedure.contracts as c until attached Result loop
				if attached {IV_PRECONDITION} c as x and then x.node_info.tag ~ tag then
					Result := x
				elseif attached {IV_POSTCONDITION} c as x and then x.node_info.tag ~ tag then
					Result := x
				end
			end
		end

	contract_by_type (type: STRING; procedure: IV_PROCEDURE): detachable IV_CONTRACT
		do
			across procedure.contracts as c until attached Result loop
				if attached {IV_PRECONDITION} c as x and then x.node_info.type ~ type then
					Result := x
				elseif attached {IV_POSTCONDITION} c as x and then x.node_info.type ~ type then
					Result := x
				end
			end
		end

	contract_by_tag_and_type (tag, type: STRING; procedure: IV_PROCEDURE): detachable IV_CONTRACT
		do
			across procedure.contracts as c until attached Result loop
				if attached {IV_PRECONDITION} c as x and then x.node_info.type ~ type
					and then x.node_info.type ~ type then
					Result := x
				elseif attached {IV_POSTCONDITION} c as x and then x.node_info.type ~ type
					and then x.node_info.type ~ type then
					Result := x
				end
			end
		end

	declarations: LINKED_LIST [IV_DECLARATION]
		do
			Result := command.autoproof.verify_task.boogie_universe.declarations
		end

	procedure_by_name (name: STRING): IV_PROCEDURE
		do
			across
				declarations as d
			until
				attached Result
			loop
				if attached {IV_PROCEDURE} d as proc and then proc.name ~ name then
					Result := proc
				end
			end
		end

	implementation_by_procedure_name (name: STRING): IV_IMPLEMENTATION
		do
			across
				declarations as d
			until
				attached Result
			loop
				if attached {IV_IMPLEMENTATION} d as i and then i.procedure.name ~ name then
					Result := i
				end
			end
		end

	inv_pre_post_contract_tags (name: STRING): TUPLE [pre, post: ARRAY [STRING]]
		local
			proc: IV_PROCEDURE
			pre, post: ARRAY [STRING]
		do
			proc := procedure_by_name (name)

			create Result
			create pre.make_empty
			create post.make_empty

			Result.pre := pre
			Result.post := post

			across proc.contracts as c loop
				if attached {IV_PRECONDITION} c as x and then x.node_info.type ~ "inv_pre" then
					Result.pre.force (x.node_info.tag, Result.pre.count + 1)
				elseif attached {IV_POSTCONDITION} c as x and then x.node_info.type ~ "inv_post" then
					Result.post.force (x.node_info.tag, Result.post.count + 1)
				end
			end
		end
end
