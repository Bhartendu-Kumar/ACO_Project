function gradient_value = objective_function_l1_gradient(x,b,A,argument_struct)


%this argument defines the type of the objective function
constrained_ls = argument_struct.constrained_least_square;

%it sets the regularization parameter
l_regularization_parameter = argument_struct.l_regularization_parameter ; 


gradient_smooth_part = (A)'*A*x - (A)'*b 
gradient_non_smooth_part = l_regularization_parameter*(constrained_ls)'*constrained_ls*x

gradient_value = gradient_smooth_part + gradient_non_smooth_part;

% end ;



% end 