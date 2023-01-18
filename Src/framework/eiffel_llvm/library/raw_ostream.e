note
	description: "Summary description for {RAW_OSTREAM}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	RAW_OSTREAM

inherit

	DISPOSABLE

feature

	item: POINTER

feature

	flush
		do
			flush_external (item)
		end

	set_unbuffered
		do
			set_unbuffered_external (item)
		end

	write (ptr: POINTER; size: NATURAL_32)
		do
			write_external (item, ptr, size)
		end

feature {NONE} -- Externals

	write_external (item_a: POINTER; ptr: POINTER; size: NATURAL_32)
		external
			"C++ inline use %"llvm/Support/FormattedStream.h%""
		alias
			"[
				((llvm::raw_ostream *)$item_a)->write ((const char *)$ptr, $size);		
			]"
		end

	set_unbuffered_external (item_a: POINTER)
		external
			"C++ inline use %"llvm/Support/FormattedStream.h%""
		alias
			"[
				((llvm::raw_ostream *)$item_a)->SetUnbuffered ();
			]"
		end

	dispose
		do
			delete (item)
			item := default_pointer
		end

	flush_external (item_a: POINTER)
		external
			"C++ inline use %"llvm/Support/FormattedStream.h%""
		alias
			"[
				((llvm::raw_ostream *)$item_a)->flush ();
			]"
		end

	delete (item_a: POINTER)
		external
			"C++ inline use %"llvm/Support/FormattedStream.h%""
		alias
			"[
				delete (llvm::raw_ostream *)$item_a;
			]"
		end
end
