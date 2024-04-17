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
			universe: IV_UNIVERSE
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

			universe := command.autoproof.verify_task.boogie_universe

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
end
