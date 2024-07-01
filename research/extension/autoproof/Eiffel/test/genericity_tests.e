note
	description: "Tests for genericity"
	testing: "autoproof", "type/manual", "execution/isolated"
class
	GENERICITY_TESTS
inherit
	AP_TEST_EXAMPLES
feature
	integer_boxing
		-- Boxing integer types in boogie to allow `x /= Void` with `x` integer.
		-- This is necessary for transpiling the integer realization from Eiffel
		-- to boogie of generics as the latter can be checked to not be void
		do
			print_file ("demo_helper.e", "[
class
	DEMO_HELPER [G]
create
	make
feature 
	
	make
		do
		end

	demo (v: G): G
		require
			v /= Void
		do
			Result := v
		ensure
			res: Result = v
		end

end
			]")

			print_file ("demo.e", "[
class
	DEMO
inherit
	DEMO_HELPER [INTEGER]
create
	make
end

			]")
			print_ecf ("DEMO")
			command.add_class ("DEMO")

			verify

			assert ("Verification succeeds", ∀ res: results ¦ res.is_verification_successful)
		end

	integer_boxing_sound
		-- Checks that a contradiction has not been added.
			do
				print_file ("demo_helper.e", "[
	class
		DEMO_HELPER [G]
	create
		make
	feature 
		
		make
			do
			end

		demo (v: G): G
			require
				v /= Void
			do
				Result := v
			ensure
				res: Result = v
				fails: False
			end

	end
				]")

				print_file ("demo.e", "[
	class
		DEMO
	inherit
		DEMO_HELPER [INTEGER]
	create
		make
	end

				]")
				print_ecf ("DEMO")
				command.add_class ("DEMO")

				verify

				assert ("Verification fails", ∃ res: results ¦ res.has_verification_errors)
			end

	boolean_boxing
		-- Boxing boolean types in boogie to allow `x /= Void` with `x` boolean.
		-- This is necessary for transpiling the boolean realization from Eiffel
		-- to boogie of generics as the latter can be checked to not be void
		do
			print_file ("demo_helper.e", "[
class
	DEMO_HELPER [G]
create
	make
feature 
	
	make
		do
		end

	demo (v: G): G
		require
			v /= Void
		do
			Result := v
		ensure
			res: Result = v
		end

end
			]")

			print_file ("demo.e", "[
class
	DEMO
inherit
	DEMO_HELPER [BOOLEAN]
create
	make
end

			]")
			print_ecf ("DEMO")
			command.add_class ("DEMO")

			verify

			assert ("Verification succeeds", ∀ res: results ¦ res.is_verification_successful)
		end

	boolean_boxing_fail
		-- This test must fail
			do
				print_file ("demo_helper.e", "[
	class
		DEMO_HELPER [G]
	create
		make
	feature 
		
		make
			do
			end

		demo (v: G): G
			require
				v /= Void
			do
				Result := v
			ensure
				res: Result = v
				fails: False
			end

	end
				]")

				print_file ("demo.e", "[
	class
		DEMO
	inherit
		DEMO_HELPER [BOOLEAN]
	create
		make
	end

				]")
				print_ecf ("DEMO")
				command.add_class ("DEMO")

				verify

				assert ("Verification succeeds", ∃ res: results ¦ res.has_verification_errors)
			end
end
