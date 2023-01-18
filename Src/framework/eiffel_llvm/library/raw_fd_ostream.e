note
	description: "Summary description for {RAW_FD_OSTREAM}."
	author: ""
	date: "$Date: 2015-04-11 05:16:01 +0800 (周六, 11 4月 2015) $"
	revision: "$Revision: 97062 $"

class
	RAW_FD_OSTREAM

inherit
	RAW_OSTREAM

create

	make_filename

feature {NONE}

	make_filename (filename: STRING)
		local
			filename_c_string: C_STRING
		do
			create filename_c_string.make (filename)
			item := ctor_filename_error_info (filename_c_string.item)
		end
		
feature

	close
		do
			close_external (item)
		end

feature {NONE} -- Externals

	close_external (item_a: POINTER)
		external
			"C++ inline use %"llvm/Support/FormattedStream.h%""
		alias
			"[
				((llvm::raw_fd_ostream *)$item_a)->close ();
			]"
		end

	ctor_filename_error_info (filename: POINTER): POINTER
		external
			"C++ inline use %"llvm/Support/FormattedStream.h%""
		alias
			"[
				std::string error;
				
				return new llvm::raw_fd_ostream ((const char *)$filename, error, 4);
			]"
		end

end
