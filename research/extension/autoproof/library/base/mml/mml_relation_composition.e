note
	description: "Helper for enabling MML_RELATIONS to be composed."
	author: "Reto Weber"
	date: "$Date$"
	revision: "$Revision$"

class
	MML_RELATION_COMPOSITION [A -> detachable ANY, B -> detachable ANY, C -> detachable ANY]

feature
	compose (rel1: MML_RELATION [A, B]; rel2: MML_RELATION [B, C]): MML_RELATION [A, C]
		local
			pairs: MML_SET [MML_PAIR [A, C]]
			current_pair: MML_PAIR [A, C]
			res_count: INTEGER
		do
			-- count the resulting size of the relation
			⟳ pair_1: rel1 ¦
				⟳ pair_2: rel2 ¦
					if pair_1.right = pair_2.left then
						res_count := res_count + 1
					end
				⟲
			⟲

			-- initialize the arrays used to build the relation
			create pairs

			-- collect values of the relation
			⟳ pair_1: rel1 ¦
				⟳ pair_2: rel2 ¦
					if pair_1.right = pair_2.left then
						create current_pair.make (pair_1.left, pair_2.right)
						if ¬pairs.has (current_pair) then
							pairs := pairs.extended (current_pair)
						end
					end
				⟲
			⟲
			create Result.make_from_set (pairs)
		ensure
			class
		end

end
