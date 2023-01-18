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

	generate_tests (a_init_states: LINKED_LIST [E2B_INITIAL_STATE_OF_ROUTINE])
			-- Generate tests from counterexample models.
		local
			l_test_generator: E2B_GENERATE_TEST_SCRIPT
					-- Generated test cases
		do
		   test_file_name := system.eiffel_project.project_directory.path.extended ("proof2test_test_set.e").out
			create l_test_generator.make (test_file_name, a_init_states)
		end


feature -- Files and data

	test_file_name: STRING_32
			-- Name of the output test file

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
