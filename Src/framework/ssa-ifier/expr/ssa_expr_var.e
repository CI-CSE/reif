note
  description: "Summary description for {SSA_EXPR_VAR}."
  author: ""
  date: "$Date: 2011-10-05 15:58:20 +0800 (Wed, 05 Oct 2011) $"
  revision: "$Revision: 87409 $"

class
  SSA_EXPR_VAR

inherit
  SSA_EXPR

create
  make

feature
  make (a_name: STRING)
    require
      not_attr: not attached class_c.feature_named_32 (a_name)
    do
      name := a_name
    end

  name: STRING

  goal_string (var_prefix: STRING): STRING
    do
      Result := var_prefix + name
    end
  
  as_code: STRING
    do
      Result := name
    end

  all_pre_conditions: ARRAYED_LIST [SSA_EXPR]
    do
      create Result.make (0)
    end
  
end
