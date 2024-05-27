note
	description: "Root class of the application."
	author: "Li Huang"
	date: "$2022-03-22$"
	revision: "$1.0$"

class
	E2B_PROOF_TO_TEST

inherit

	SHARED_WORKBENCH

create
	make

feature {NONE} -- Initialize

	make
			-- Initialization
		do

		end

feature -- Tests generation

	generate_tests (a_init_states: LINKED_LIST [TUPLE [
		state: E2B_CE_STATE_OF_ROUTINE; target_class: E2B_CLASS_C; target_feature: E2B_FEATURE_I]])
			-- Generate tests from counterexample models.
		local
			l_test_generator: E2B_GENERATE_TEST_SCRIPT
					-- Generated test cases
		do
		   test_file_name := system.eiffel_project.project_directory.path.extended ("failed_tests.e").out
			create l_test_generator.make (test_file_name, a_init_states)
		end

	generate_test_for_ce (a_init_state: E2B_CE_STATE_OF_ROUTINE; a_target_class: E2B_CLASS_C; a_target_feature: E2B_FEATURE_I)
			-- Generate a test from a single counterexample model
		local
			l_test_generator: E2B_GENERATE_TEST_SCRIPT
		do
			file_index := file_index + 1
			test_file_name := system.eiffel_project.project_directory.path.extended (a_target_class.name + "_failed_test_" + file_index.out + ".e").out
			create l_test_generator.make (
				test_file_name,
				create {LINKED_LIST [TUPLE [E2B_CE_STATE_OF_ROUTINE, E2B_CLASS_C, E2B_FEATURE_I]]}
					.make_from_iterable (<< [a_init_state, a_target_class, a_target_feature] >>))
		end

feature -- Files and data

	test_file_name: STRING
			-- Name of the output test file

	file_index: INTEGER
			-- Number of test files

;

note
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
