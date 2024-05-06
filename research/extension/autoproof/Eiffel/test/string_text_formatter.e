note
	description: "TEXT_FORMATTER which collects text into a string"

class
	STRING_TEXT_FORMATTER

inherit
	TEXT_FORMATTER
		redefine
			default_create
		end

create
	default_create

feature
	default_create
		do
			create buffer.make_empty
		end

	buffer: STRING_32

	process_basic_text, process_quoted_text,
		process_symbol_text (text: READABLE_STRING_GENERAL)
		do
			buffer := buffer + text
		end

	process_target_name_text (text: READABLE_STRING_GENERAL; a_target: CONF_TARGET)
		do
		end

	process_feature_name_text (text: READABLE_STRING_GENERAL; a_class: CLASS_C)
		do
		end

	process_feature_text (text: READABLE_STRING_GENERAL; a_feature: E_FEATURE; a_quote: BOOLEAN)
		do
		end

	process_breakpoint_index (a_feature: E_FEATURE; a_index: INTEGER; a_cond: BOOLEAN)
		do
		end

	process_breakpoint (a_feature: E_FEATURE; a_index: INTEGER)
		do
		end

	process_padded, process_new_line
		do
		end

	process_indentation (a_indent_depth: INTEGER)
		do
		end

	process_after_class, process_before_class (a_class: CLASS_C)
		do
		end

	process_filter_item (text: READABLE_STRING_GENERAL; is_before: BOOLEAN)
		do
		end

	process_keyword_text,
		process_operator_text (text: READABLE_STRING_GENERAL; a_feature: detachable E_FEATURE)
		do
		end

	process_address_text (a_address, a_name: READABLE_STRING_GENERAL; a_class: CLASS_C)
		do
		end

	process_error_text (text: READABLE_STRING_GENERAL; a_error: ERROR)
		do
		end

	process_cl_syntax (text: READABLE_STRING_GENERAL; a_syntax_message: ERROR; a_class: CLASS_C)
		do
		end

	process_cluster_name_text (text: READABLE_STRING_GENERAL; a_group: CONF_GROUP;
		a_quote: BOOLEAN)
		do
		end

	process_comment_text (text, url: READABLE_STRING_GENERAL)
		do
			process_basic_text (text)
			if url /= Void then
				process_basic_text (url)
			end
		end

	process_class_name_text (text: READABLE_STRING_GENERAL; a_class: CLASS_I; a_quote: BOOLEAN)
		do
		end

end
