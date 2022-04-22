function return_value = bb_projection_operator(input_variable,parameter_l)
    temp = input_variable;
return_value = min(max(input_variable,-ones(size(input_variable))*parameter_l),ones(size(input_variable))*parameter_l);
end