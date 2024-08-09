note
	description: "High level declaration which registers a new object field"

class
	IV_FIELD_ID_AXIOM

inherit
	IV_AXIOM
		rename
			make as axiom_make
		end

	IV_SHARED_FACTORY

	IV_SHARED_TYPES

create
	make

feature
	make (a_field_name: READABLE_STRING_8;
		a_field_type: IV_TYPE;
		a_context_type: E2B_CL_TYPE_A;
		a_id: INTEGER)
			-- Define a field named `a_field_name` of type `a_field_type`
			-- in type `a_context_type` with field id `a_id`.
		do
			field_name := a_field_name
			field_type := a_field_type
			context_type := a_context_type
			id := a_id

			axiom_make (factory.equal (
				factory.function_call ("FieldId", <<
						factory.entity (field_name, types.field (field_type)),
						factory.type_value (context_type)
					>>,
					types.int),
				factory.int_value (id)
			))
		end

	field_name: READABLE_STRING_8
	field_type: IV_TYPE
	context_type: E2B_CL_TYPE_A
	id: INTEGER
end
