note
	description: "Interface for drawable objects"
	author: ""
	date: "$Date: 2011-11-22 05:27:45 +0800 (周二, 22 11月 2011) $"
	revision: "$Revision: 87923 $"

deferred class
	NATIVE_DRAWABLE_I

feature {NATIVE_DRAWABLE_CONTEXT}

	drawable_handle: POINTER
			-- Handle to drawable object.
		deferred
		end

end
