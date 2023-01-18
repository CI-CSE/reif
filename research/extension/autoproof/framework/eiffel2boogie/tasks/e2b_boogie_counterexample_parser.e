note
	description: "Summary description for {E2B_BOOGIE_COUNTEREXAMPLE_PARSER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	E2B_BOOGIE_COUNTEREXAMPLE_PARSER

create
	make

feature
	make (model_file_name: STRING_32)
			-- Initialization
		local
			model_file: PLAIN_TEXT_FILE
			model_file_content: STRING_32
			models: ARRAY [IMMUTABLE_STRING_32]

		do
			model_file_content := ""
			create models.make_empty

			create model_file.make_open_read (model_file_name)
			print ("model file: " + model_file_name.to_string_8 + "%N")
			model_file.read_stream (1000000)
			model_file_content.copy (model_file.last_string)

			models := split_models (model_file_content)

			create counterexamples.make (0)
			parse_models (models)

		end

feature

	split_models (model_file_content: STRING_32): ARRAY [IMMUTABLE_STRING_32]
			-- Split the content of the input .model file into a list of models
		require
			model_not_empty: not model_file_content.is_empty
		local
			i, end_of_model: INTEGER
			model: STRING_32
			models: ARRAY [IMMUTABLE_STRING_32]
		do
			create models.make_empty
			from
				i := 1
				model := ""
			until
				i = model_file_content.count

			loop
				end_of_model := model_file_content.substring_index ("END_MODEL", i)
				if end_of_model /= 0 then
					model.copy (model_file_content.substring (i, end_of_model))
					models.force (model, models.count + 1)
					i := end_of_model + 1
				else
					i := model_file_content.count
				end
			end

			Result := models
		end

	parse_models (models: ARRAY [IMMUTABLE_STRING_32])
			-- Parse the model text and collect the counterexample information
		local
			ce: E2B_BOOGIE_COUNTEREXAMPLE
		do
			across models as m loop
				create ce.make (m)
				if counterexamples.has (ce.class_name + "." + ce.routine_name) then
					counterexamples [ce.class_name + "." + ce.routine_name].force (ce, counterexamples [ce.class_name + "." + ce.routine_name].count + 1)
				else
					counterexamples.extend (<<ce>>, ce.class_name + "." + ce.routine_name)
				end
			end
		end

feature

	counterexamples: HASH_TABLE [ARRAY [E2B_BOOGIE_COUNTEREXAMPLE], IMMUTABLE_STRING_32]
			-- Mapping from a target routine to a list of counterexamples

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
