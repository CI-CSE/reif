class
	DP_DEAD_PLAN

inherit
	SHARED_WORKBENCH

create
	make

feature

	make (a_class_name, a_feature_name: READABLE_STRING_GENERAL)
		do
			planned_class_name := a_class_name
			planned_feature_name := a_feature_name
		end

	planned_class_name: READABLE_STRING_GENERAL
	planned_feature_name: READABLE_STRING_GENERAL

	execute
		do
			-- After process_degree_3 in SYSTEM_I
			plan_generate_class

		end


	plan_generate_class
		local
			ssaifier: SSAIFIER
			class_: CLASS_C
		do
			plan_generate_domain
			class_ := find_class (planned_class_name)
			if attached planned_class_name then
				create ssaifier.make (class_, planned_feature_name)
--				ssaifier.write_default_plan
			end
		end

	plan_generate_domain
		local
			class_: CLASS_C
			domifier: SSA_DOMAINIFIER
		do
			class_ := find_class (planned_class_name)
			if attached class_ then
				create domifier.make (class_)
				domifier.write_domain_files
				domifier.write_gen_dom_file
			end
		end

	find_class (a_class_name: READABLE_STRING_GENERAL): CLASS_C
		local
			i: INTEGER
			done: BOOLEAN
		do
			if attached a_class_name then
				from i := 1
				until i > workbench.system.classes.count or done
				loop
					if attached workbench.system.classes[i] then
					    if a_class_name.as_lower.same_string (workbench.system.classes [i].name.as_lower) then
					    	done := True
							Result := workbench.system.classes [i]
					    end
					end
					i := i + 1
				end
			end
		end

end
