note
	description: "An implementation of a context menu extension service."

class
	AP_ES_CONTEXT_MENU_EXTENSION

inherit
	CONTEXT_MENU_EXTENSION_S
	DISPOSABLE_SAFE
	EB_SHARED_PIXMAPS
	SHARED_LOCALE

feature -- Modification

	extend_feature
		(f: E_FEATURE;
		extender: PROCEDURE [
			READABLE_STRING_32, -- name
			READABLE_STRING_8, -- icon
			BOOLEAN, -- is_sensitive
			PROCEDURE -- action
		])
			-- <Precursor>
		local
			is_running: BOOLEAN
		do
			if
				attached verifier.service as s and then
				f.associated_feature_i.has_code
			then
				is_running := s.is_running
				extender
					(if is_running then
						locale.translation_in_context ("Verify with AutoProof (running)", "menu.feature")
					else
						locale.translation_in_context ("Verify with AutoProof", "menu.feature")
					end,
					icon_pixmaps.verifier_verify_feature_name,
					not is_running,
					agent s.verify_feature (f))
			end
		end

	extend_class (c: CLASS_C; extender:
		PROCEDURE [
			READABLE_STRING_32, -- name
			READABLE_STRING_8, -- icon
			BOOLEAN, -- is_sensitive
			PROCEDURE -- action
		])
			-- <Precursor>
		local
			is_running: BOOLEAN
		do
			if attached verifier.service as s then
				is_running := s.is_running
				extender
					(if is_running then
						locale.translation_in_context ("Verify with AutoProof (running)", "menu.class")
					else
						locale.translation_in_context ("Verify with AutoProof", "menu.class")
					end,
					icon_pixmaps.verifier_verify_class_name,
					not is_running,
					agent s.verify_class (c))
			end
		end

feature {NONE} -- Clean up

	safe_dispose (a_explicit: BOOLEAN)
			-- <Precursor>
		do
		end

feature {NONE} -- Service access

	verifier: SERVICE_CONSUMER [VERIFIER_S]
			-- Access to the verfier service.
		once
			create Result
		end

end
