class F_OOO_OBSERVER

create
	make

feature {NONE} -- Initialization

	make (s: F_OOO_SUBJECT)
		note
			status: creator
		require
			s.observer = Void
		do
			subject := s
			s.register (Current)
			check s.inv end
			cache := s.value
		ensure
			modify (Current)
			modify_field (["observer", "observers", "closed"], s)
			subject = s
		end

feature -- Access

	cache: INTEGER
			-- Cached value of subject.

	subject: F_OOO_SUBJECT
			-- Subject of this observer.

feature {F_OOO_SUBJECT} -- Element change

	notify
		require
			open: is_open
			almost_holds: inv_without ("cache_synchronized")

		do
			cache := subject.value
		ensure
			modify_field ("cache", Current)
			invariant_holds: inv
		end

invariant
	subject_exists: attached subject
	subjects_structure: subjects = create {MML_SET [ANY]}.singleton (subject)
	subject_aware: subject.observer = Current
	cache_synchronized: cache = subject.value

end
