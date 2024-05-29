class B_REFERENCES

feature

	void_check
		local
			a: ANY
		do
			check a = Void end
			check not attached a end
		end

	void_call
		local
			a: ANY
		do
			a.do_nothing
		end
end
