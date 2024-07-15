note
	description: "ES execution adapted for usage in tests (namely AP_TEST_EXAMPLES)"

class
	AP_TEST_ES

inherit
	ES_BATCH
		rename
			make as es_make
		export
			{ANY} execute
		redefine
			argument, argument_count
		end

create
	make

feature
	make (a_arguments: like arguments)
			-- Initialization
		local
			l_layout: ES_EIFFEL_LAYOUT
			l_eifgen_init: INIT_SERVERS
		do
			arguments := a_arguments

				-- Code analysis command state is kept in a separate object
				-- that accumulates the corresponding requests.
			create code_analysis_command.make
				-- A parser to process configutation options specified in the command line.
			create configuration_option_parser.make
				(agent: ITERABLE [READABLE_STRING_32]
					local
						t: like eiffel_layout.default_il_environment.installed_runtimes
						n: ARRAYED_LIST [READABLE_STRING_32]
					do
							-- agent eiffel_layout.default_il_environment.installed_runtimes
							-- would work, but it would cause computation of CLR run-times
							-- immediately though it might be never required.
							-- Therefore we are using the inline agent instead.
						t := eiffel_layout.default_il_environment.installed_runtimes
						create n.make (t.count)
						⟳ r: t ¦ n.extend (@ r.key) ⟲
						Result := n
					end)
				-- Check that environment variables
				-- are properly set.
			if not is_eiffel_layout_defined then
				create l_layout
				l_layout.check_environment_variable
				set_eiffel_layout (l_layout)
			end

				-- Set the default project path to the current working directory.
				-- This may be overriden via user settings.
			project_path :=(create {EXECUTION_ENVIRONMENT}).current_working_path

				--| Initialization of the run-time, so that at the end of a store/retrieve
				--| operation (like retrieving or storing the project, creating the CASEGEN
				--| directory, generating the profile information, ...) the run-time is initialized
				--| back to the values which permits the compiler to access correctly the EIFGEN
				--| directory
			create l_eifgen_init.make

				-- Initialization of compiler resources
			;(create {TTY_RESOURCES}.initialize).do_nothing

				-- Initialization of compiler resources.

			create preference_access.make_with_defaults_and_location_and_version (
				<<eiffel_layout.general_preferences.name, eiffel_layout.platform_preferences.name>>, eiffel_layout.eiffel_preferences, version_2_0)
			;(create {SETTABLE_COMPILER_OBJECTS}).set_preferences (create {EC_PREFERENCES}.make (preference_access))

				-- Remaining initialization
			initialize
		end

	arguments: ARRAY [IMMUTABLE_STRING_32]

	argument (i: INTEGER): IMMUTABLE_STRING_32
		do
			Result := arguments [i]
		end

	argument_count: INTEGER
		do
			Result := arguments.count
		end

	preference_access: PREFERENCES
end
