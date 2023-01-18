note
	description: "[
		Graph printer to output a graph in DOT format
		Check http://www.graphviz.org/ for more information about DOT format.
		]"
	author: ""
	date: "$Date: 2010-05-30 18:37:08 +0800 (Sun, 30 May 2010) $"
	revision: "$Revision: 83368 $"

deferred class
	EGX_DOT_GRAPH_PRINTER [N -> HASHABLE, L]

inherit
	EGX_GRAPH_PRINTER [N, L]

end
