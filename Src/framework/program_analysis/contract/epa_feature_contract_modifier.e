note
	description: "Summary description for {EPA_FEATURE_CONTRACT_REMOVER}."
	author: ""
	date: "$Date: 2015-11-19 21:59:02 +0800 (Thu, 19 Nov 2015) $"
	revision: "$Revision: 98118 $"

class
	EPA_FEATURE_CONTRACT_MODIFIER_FOR_FAILURE

inherit
	AST_ITERATOR
		redefine
			process_check_as
		end

	SHARED_SERVER

	EPA_UTILITY

create
	make

feature -- Initialization

	make(a_feature: EPA_FEATURE_WITH_CONTEXT_CLASS)
		-- Initialize with `a_feature'
		do
			target_feature := a_feature.twin
			target_class := target_feature.context_class
			target_feature_name := target_feature.feature_.feature_name
		end

--	modify_contracts_for_feature (a_feature: AFX_FEATURE_TO_MONITOR; a_contracts: EPA_HASH_SET [EPA_EXPRESSION]; a_failure_msg: STRING):  DS_ARRAYED_LIST [AFX_CODE_FIX_TO_FAULT]
--		-- Modify contracts of `a_feature' based on two strategy
--		-- 1) strengthening precondition by adding negation of counterexample properties
--		-- 2) weakening postconditions using implication clauses
--		local
--			l_class_texts: DS_HASH_TABLE [STRING, STRING]
--			l_new_features_text: ARRAYED_LIST [STRING]
--			l_code_fix: AFX_CODE_FIX_TO_FAULT
--			l_fixing_target: AFX_FIXING_TARGET

--		do
--			-- initialize_features_with_declarations (a_features)
--			create l_new_features_text.make (0)

--			target_feature := a_feature.twin
--			target_class := target_feature.context_class
--			target_feature_name := target_feature.feature_.feature_name

--			across a_contracts as c loop
--				create l_fixing_target.make (c.item, 1, 1.0)
--				feature_index := feature_index + 1
--				l_text := feature_text_with_strengthened_precondition (c.item)
--				-- l_new_features_text.force (l_text)

--				Result.append_last (create {AFX_CODE_FIX_TO_FAULT}.make (a_feature, l_fixing_target, l_text, 1))

--				feature_index := feature_index + 1
--				l_text := feature_text_with_weakened_postcondition (c.item, a_failure_msg)
--				Result.append_last (create {AFX_CODE_FIX_TO_FAULT}.make (a_feature, l_fixing_target, l_text, 1))
--				-- l_new_features_text.force (feature_text_with_weakened_postcondition (c.item, a_failure_msg))
--			end

--			-- Put all the fixes in the same class file
--			-- Use one or two run of verification only			



--			l_class_texts := class_texts_with_new_features_added (l_new_features_text)

--			save_class_texts (l_class_texts)
--		end

	undo_last_operation
		local
			l_cursor: DS_ARRAYED_LIST_CURSOR [PATH]
			l_file: PLAIN_TEXT_FILE
		do
			if last_generated_new_class_paths /= Void and then not last_generated_new_class_paths.is_empty then
				from
					l_cursor := last_generated_new_class_paths.new_cursor
					l_cursor.start
				until
					l_cursor.after
				loop
					create l_file.make_with_path (l_cursor.item)
					if l_file.exists then
						l_file.delete
					end
					l_cursor.forth
				end

				last_generated_new_class_paths := Void
			end
		end

feature -- Status report

	is_last_removal_successful: BOOLEAN
			-- Is last removal successful?

feature{NONE} -- Access

	last_generated_new_class_paths: DS_ARRAYED_LIST [PATH]

	target_feature: EPA_FEATURE_WITH_CONTEXT_CLASS
		-- Target feature with context class

	target_feature_name: STRING
		-- Name of the target feature

	target_class: CLASS_C
		-- Target class

	last_expression: STRING
		-- Lastly appended expression

	-- feature_index: INTEGER
		-- Index of the new feature

feature -- {EPA_FEATURE_CONTRACT_MODIFIER_FOR_FAILURE, AFX_FIXER} -- Implementation


	feature_text_with_strengthened_precondition (a_contract: EPA_EXPRESSION; a_feature_index: INTEGER): STRING
			-- Add `a_contract' to the precondition of target feature
			-- Return the text of new feature
		local
			l_asts: DS_ARRAYED_LIST [TAGGED_AS]
			l_match_list: LEAF_AS_LIST
			l_text: STRING
		do
			Result := ""
			create l_asts.make_equal (10)

			l_asts.append_last (precondition_asts_from_feature (target_feature.feature_)) -- AST node of preconditions

			l_match_list := Match_list_server.item (target_class.class_id) -- Match list of current class

			if not l_asts.is_empty then
				l_asts.last.append_text ("%N" + a_contract.text, l_match_list)
				last_expression := l_asts.last.text (l_match_list)
			 -- append text at the node of last precondition
				l_text := target_class.ast.feature_of_name (target_feature_name, False).text (l_match_list) -- resulting feature text
			else -- add a node of precondition TODO Li: this is a hack to add new precondition if there's no in the original feature
				l_text := target_class.ast.feature_of_name (target_feature_name, False).text (l_match_list)
				if l_text.has_substring ("local") then
					l_text.replace_substring_all ("local", "%Nrequire%N" + a_contract.text + "%Nlocal%N")
				else
					l_text.replace_substring_all ("do", "%Nrequire%N" + a_contract.text + "%Ndo%N")
				end

			end

			l_text.replace_substring (target_feature_name + "_ID_" + a_feature_index.out, 1, target_feature_name.count)
			Result.copy ("%N%N" + l_text)
			l_match_list.remove_modifications
 		end

	feature_text_with_weakened_postcondition (a_contract: EPA_EXPRESSION; a_failure_msg: STRING; a_feature_index: INTEGER): STRING
			-- Add `a_contract' to the precondition of target feature
			-- Return the text of new feature
		local
			l_ast: TAGGED_AS
			l_match_list: LEAF_AS_LIST
			l_text, l_tag, l_new_post: STRING
		do
			Result := ""
			-- create l_asts.make_equal (10)
			l_match_list := Match_list_server.item (target_class.class_id) -- Match list of current class

			l_tag := a_failure_msg.twin

			l_ast := postcondition_of_tag_asts_from_feature (target_feature.feature_, l_tag) -- AST node of failed postcondition
			if not attached l_ast then -- TODO Li: support postcondition and class invariant only
				-- target_class.ast.invariant_part.assertion_list
				l_ast := invariant_of_tag_asts_from_class (target_class, l_tag)
			end
			last_expression := l_ast.text (l_match_list)
			print (a_contract.text + "%N")
			l_new_post := "%N" + l_tag + ":" + a_contract.text +  "implies " + "(" + last_expression.substring (l_tag.count + 2, last_expression.count) + ")"

			l_ast.replace_subtext (last_expression, "%N" + l_new_post, True, l_match_list)

			 -- append text at the node of last precondition

			l_text := target_class.ast.feature_of_name (target_feature_name, False).text (l_match_list) -- resulting feature text
			l_text.replace_substring (target_feature_name + "_ID_" + a_feature_index.out, 1, target_feature_name.count)
			Result.copy ("%N%N" + l_text)
			l_match_list.remove_modifications
		end

--	feature_text_with_weakened_assertion (a_contract: EPA_EXPRESSION): STRING
--			-- Add `a_contract' to the precondition of target feature
--			-- Return the text of new feature
--		local
--			l_asts: DS_ARRAYED_LIST [TAGGED_AS]
--			l_match_list: LEAF_AS_LIST
--			l_text: STRING
--		do
--			-- TODO Li
--			Result := ""
--			create l_asts.make_equal (10)

--			l_asts.append_last (postcondition_of_tag_asts_from_feature (target_feature.feature_)) -- AST node of preconditions

--			l_match_list := Match_list_server.item (target_class.class_id) -- Match list of current class

--			if feature_index = 1 then
--				l_asts.last.append_text ("%N" + a_contract.text, l_match_list)
--			else
--				l_asts.last.replace_subtext (last_expression, "%N" + a_contract.text, True, l_match_list)
--			end

--			last_expression := l_asts.last.text (l_match_list)
--			 -- append text at the node of last precondition

--			l_text := target_class.ast.feature_of_name (target_feature_name, False).text (l_match_list) -- resulting feature text
--			l_text.replace_substring (target_feature_name + "_id_" + feature_index.out, 1, target_feature_name.count)
--			Result.copy ("%N%N" + l_text)
--		end


	class_texts_with_new_features_added (a_new_features_text: ARRAYED_LIST [STRING]): DS_HASH_TABLE [STRING, STRING]
			--
		local
			l_table_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN], CLASS_C]
			l_change_type: BOOLEAN
			l_table_for_class: DS_HASH_TABLE [DS_HASH_SET [FEATURE_I], BOOLEAN]
			l_table_for_class_cursor: DS_HASH_TABLE_CURSOR [DS_HASH_SET [FEATURE_I], BOOLEAN]

			l_class_file_name, l_class_text: STRING
			l_match_list: LEAF_AS_LIST
		do
			create Result.make_equal (10)
			create l_class_text.make (4096)
			l_class_file_name := target_class.name.as_lower
			l_match_list := Match_list_server.item (target_class.class_id)

			across a_new_features_text as l_text loop
				target_class.ast.feature_of_name (target_feature_name, False).append_text (l_text.item, l_match_list)
			end


--			from
--				l_ast_cursor := l_asts.new_cursor
--				l_ast_cursor.start
--			until
--				l_ast_cursor.after
--			loop
--				l_ast_cursor.item.replace_subtext (":", new_contract.text, true, l_match_list)
--				-- l_ast_cursor.item.prepend_text ("not", l_match_list)
--				-- l_ast_cursor.item.replace_text ("True", l_match_list)
--				l_ast_cursor.forth
--			end

			-- Result.force (l_class.ast.text (l_match_list).twin, l_class_file_name)

			Result.force (target_class.ast.text (l_match_list).twin, l_class_file_name)

			l_match_list.remove_modifications
	end

	add_all_tagged_as (a_eiffel_list: EIFFEL_LIST [TAGGED_AS]; a_list_of_as: DS_ARRAYED_LIST [TAGGED_AS])
			--
		local
			l_cursor: INDEXABLE_ITERATION_CURSOR [TAGGED_AS]
		do
			from
				l_cursor := a_eiffel_list.new_cursor
				l_cursor.start
			until
				l_cursor.after
			loop
				a_list_of_as.force_last (l_cursor.item)
				l_cursor.forth
			end
		end

	precondition_asts_from_feature (a_feature: FEATURE_I): DS_ARRAYED_LIST [TAGGED_AS]
			-- List of AST nodes from the text of `a_feature' that are contract clauses.
			--
			-- At most one node for "require/require else", one node for "ensure/ensure then",
			--		and one node for each check instruction.
		require
			feature_attached: a_feature /= Void
		local
		do
			create Result.make (4)
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if l_rout.precondition /= Void and then l_rout.precondition.assertions /= Void then
					add_all_tagged_as (l_rout.precondition.assertions, Result)
				end
			end
		end

	postcondition_of_tag_asts_from_feature (a_feature: FEATURE_I; a_tag: STRING): TAGGED_AS
			-- List of AST nodes from the text of `a_feature' that are contract clauses.
			--
			-- At most one node for "require/require else", one node for "ensure/ensure then",
			--		and one node for each check instruction.
		require
			feature_attached: a_feature /= Void
		local
			l_assertion_list: DS_ARRAYED_LIST [TAGGED_AS]
		do
			-- create Result.make (4)
			create l_assertion_list.make (4)

			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				if l_rout.postcondition /= Void and then l_rout.postcondition.assertions /= Void then
					add_all_tagged_as (l_rout.postcondition.assertions, l_assertion_list)

					across l_assertion_list as post loop
						if attached post.item.tag and post.item.tag.name ~ a_tag then
							Result := post.item
						end
					end
				end
			end
		end

	invariant_of_tag_asts_from_class (a_class: CLASS_C; a_tag: STRING): TAGGED_AS
			-- List of AST nodes from the text of `a_feature' that are contract clauses.
			--
			-- At most one node for "require/require else", one node for "ensure/ensure then",
			--		and one node for each check instruction.
		require
			feature_attached: a_class /= Void
		local
			l_assertion_list: DS_ARRAYED_LIST [TAGGED_AS]
		do
			-- create Result.make (4)
			create l_assertion_list.make (4)

			if attached a_class.ast.invariant_part as l_inv then
				if l_inv.assertion_list /= Void then
					add_all_tagged_as (l_inv.assertion_list, l_assertion_list)

					across l_assertion_list as inv loop
						if attached inv.item.tag and inv.item.tag.name ~ a_tag then
							Result := inv.item
						end
					end
				end
			end
		end

	check_assertion_asts_from_feature (a_feature: FEATURE_I): DS_ARRAYED_LIST [TAGGED_AS]
			-- List of AST nodes from the text of `a_feature' that are contract clauses.
			--
			-- At most one node for "require/require else", one node for "ensure/ensure then",
			--		and one node for each check instruction.
		require
			feature_attached: a_feature /= Void
		local
		do
			create Result.make (4)
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				collect_checks_from_feature (a_feature)
				Result.append_last (check_lists)
			end
		end

	save_class_texts (a_class_texts: DS_HASH_TABLE [STRING, STRING])
			--
		local
			l_path: PATH
			l_dir: DIRECTORY
			l_table_cursor: DS_HASH_TABLE_CURSOR [STRING, STRING]
			l_class_file_name, l_class_text: STRING
			l_class_file_path: PATH
			l_class_file: PLAIN_TEXT_FILE
		do
			create last_generated_new_class_paths.make_equal (a_class_texts.count + 1)

				-- Store the new class file into OVERRIDE cluster.
			l_path := system.eiffel_project.project_directory.path.extended ("override")
			create l_dir.make_with_path (l_path)
			if not l_dir.exists then
				l_dir.recursive_create_dir
			end

			from
				l_table_cursor := a_class_texts.new_cursor
				l_table_cursor.start
			until
				l_table_cursor.after
			loop
				l_class_file_name := l_table_cursor.key
				l_class_text := l_table_cursor.item

				l_class_file_path := l_path.extended (l_class_file_name + ".e")
				last_generated_new_class_paths.force_last (l_class_file_path)
				create l_class_file.make_with_path (l_class_file_path)
				l_class_file.open_write
				l_class_file.put_string (l_class_text)
				print ("l_class_file_name: " + l_class_file_name + "%N%N")
				print (l_class_text + "%N")
				l_class_file.close

				l_table_cursor.forth
			end
		end

feature{NONE} -- Collect check assertions

	check_lists: DS_ARRAYED_LIST [TAGGED_AS]

	collect_checks_from_feature (a_feature: FEATURE_I)
			-- Collect assertion clauses in CHECK instructions from `a_feature'.
			-- Make result available in `check_lists'.
		require
			feature_attached: a_feature /= Void
		local
		do
			create check_lists.make (10)
			if attached a_feature.e_feature.ast.body.as_routine as l_rout then
				l_rout.process (Current)
			end
		end

	process_check_as (l_as: CHECK_AS)
			-- <Precursor>
		do
			add_all_tagged_as (l_as.check_list, check_lists)
		end



end
