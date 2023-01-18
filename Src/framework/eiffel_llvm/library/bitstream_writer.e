note
	description: "Summary description for {BITSTREAM_WRITER}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	BITSTREAM_WRITER

obsolete "Changed signature"

--create

--	make

--feature {NONE}

--	make (vector_a: UNSIGNED_CHAR_VECTOR)
--		do
--			item := make_external (vector_a.item)
--		end

--feature

--	item: POINTER

--feature {NONE} -- Externals

--	make_external (vector_a: POINTER): POINTER
--		external
--			"C++ inline use %"llvm/Bitcode/BitstreamWriter.h%""
--		alias
--			"[
--				return new llvm::BitstreamWriter (*((std::vector <unsigned char> *)$vector_a));
--			]"
--		end
end
