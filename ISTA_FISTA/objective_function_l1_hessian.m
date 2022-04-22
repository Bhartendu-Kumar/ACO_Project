function Hessian = objective_function_l1_hessian(x,b,A,argument_struct)





%this argument defines the type of the objective function
constrained_ls = argument_struct.constrained_least_square;

%it sets the regularization parameter
l_regularization_parameter = argument_struct.l_regularization_parameter ; 


A_transpose_A = A'*A;

Hessian = A_transpose_A + l_regularization_parameter*(constrained_ls)'*constrained_ls;



% end 