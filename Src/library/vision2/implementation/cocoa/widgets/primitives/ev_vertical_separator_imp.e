note
	description: "EiffelVision vertical separator, Cooca implementation"
	author:	"Daniel Furrer"
	date: "$Date: 2013-05-21 07:15:17 +0800 (周二, 21 5月 2013) $";
	revision: "$Revision: 92557 $"

class
	EV_VERTICAL_SEPARATOR_IMP

inherit
	EV_VERTICAL_SEPARATOR_I
		redefine
			interface
		end

	EV_SEPARATOR_IMP
		redefine
			interface
		end

create
	make

feature {EV_ANY, EV_ANY_I} -- Implementation

	interface: detachable EV_VERTICAL_SEPARATOR note option: stable attribute end;

end -- class EV_VERTICAL_SEPARATOR_IMP
