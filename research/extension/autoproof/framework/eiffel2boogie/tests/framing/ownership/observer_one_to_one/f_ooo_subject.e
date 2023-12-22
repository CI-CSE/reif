class F_OOO_SUBJECT

inherit

	ANY
		redefine
			default_create
		end

feature {NONE} -- Initialization

	default_create
		note
			status: creator
		do
		ensure then
			observer = Void -- default: default_create
		end

feature -- Access

	value: INTEGER
		-- Subject's value.

	observer: detachable F_OOO_OBSERVER
		-- Observer of this subject.

feature -- Element change

	update (new_val: INTEGER)
		require
			observer_wrapped: observer /= Void implies observer.is_wrapped
		do
			if attached observer then
				observer.unwrap
			end
			value := new_val
			if attached observer then
				observer.notify
				observer.wrap
			end
		ensure
			modify_field (["cache", "closed"], observer)
			modify_field (["value", "closed"], Current)
			value_set: value = new_val
			observer_wrapped: observer /= Void implies observer.is_wrapped
		end

feature {F_OOO_OBSERVER} -- Element change

	register (o: F_OOO_OBSERVER)
			-- Register `o' as observer.
		require
			observer = Void
			is_wrapped
			o.is_open
		do
			unwrap
			observer := o
			set_observers (create {MML_SET [ANY]}.singleton (o))
			wrap
		ensure
			modify_field (["observer", "observers", "closed"], Current)

			observer = o
			is_wrapped
		end

invariant
	observer = Void implies observers = create {MML_SET [ANY]}
	observer /= Void implies observers = create {MML_SET [ANY]}.singleton (observer)
	observer /= Current

end
