note
	description: "[
		TODO
	]"
	date: "$Date: 2014-01-31 01:50:59 +0800 (Fri, 31 Jan 2014) $"
	revision: "$Revision: 94130 $"

class
	IV_GOTO

inherit

	IV_STATEMENT

create
	make, make_empty

feature {NONE} -- Initialization

	make_empty
			-- Initialize goto statement without targets.
		do
			create blocks.make
		end

	make (a_block: IV_BLOCK)
			-- Initialize goto statement with target `a_block'.
		require
			a_block_attached: attached a_block
		do
			create blocks.make
			blocks.extend (a_block)
		ensure
			block_added: blocks.first = a_block
		end

feature -- Access

	blocks: LINKED_LIST [IV_BLOCK]
			-- List of target blocks for goto.

feature -- Element change

	add_target (a_block: IV_BLOCK)
			-- Add `a_block' as a target for goto.
		require
			a_block_attached: attached a_block
		do
			blocks.extend (a_block)
		ensure
			block_added: blocks.last = a_block
		end

feature -- Visitor

	process (a_visitor: IV_STATEMENT_VISITOR)
			-- <Precursor>
		do
			a_visitor.process_goto (Current)
		end

invariant
	blocks_attached: attached blocks
	blocks_valid: not blocks.has (Void)

end
