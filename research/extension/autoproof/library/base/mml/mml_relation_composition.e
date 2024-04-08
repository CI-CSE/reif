note
	description: "Summary description for {MML_RELATION_TRANSITION}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	MML_RELATION_COMPOSITION [A -> detachable ANY, B -> detachable ANY, C -> detachable ANY]

feature
	compose (rel1: MML_RELATION [A, B]; rel2: MML_RELATION [B, C]): MML_RELATION [A, C]
		local
			ls: ARRAY [A]
			rs: ARRAY [C]
			res_index: INTEGER
		do
			create ls.make (1, rel2.lefts.count)
			create rs.make (1, rel2.rights.count)
			res_index := ls.lower
			across rel1 as c_rel
			loop
				across rel2 as o_rel
				loop
					if c_rel.right = o_rel.left then
						ls [res_index] := c_rel.left
						rs [res_index] := o_rel.right
						res_index := res_index + 1
					end
				end
			end
			ls.keep_head (res_index - 1)
			rs.keep_head (res_index - 1)
			create Result.make_from_arrays (ls, rs)
		ensure
			class
		end

end
