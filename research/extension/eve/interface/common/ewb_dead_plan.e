note
	description: "Command for Dead Plan"

class
	EWB_DEAD_PLAN

inherit
	E_CMD

create

	make

feature {NONE} -- Initialization

	make (a_class_name, a_feature_name: READABLE_STRING_GENERAL)
		do
			class_name := a_class_name
			feature_name := a_feature_name
		end

	class_name: READABLE_STRING_GENERAL
	feature_name: READABLE_STRING_GENERAL

feature


	execute
		do
			(create {DP_DEAD_PLAN}.make (class_name, feature_name)).execute
		end
end
