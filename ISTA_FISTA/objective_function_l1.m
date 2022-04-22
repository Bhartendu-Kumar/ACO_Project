function cost = objective_function_l1(x,b,A,argument_struct)



%this argument defines the type of the objective function
constrained_ls = argument_struct.constrained_least_square;

%it sets the regularization parameter
l_regularization_parameter = argument_struct.l_regularization_parameter ; 


degraded_image = A*x;
vector_inside_l1_norm = constrained_ls*x;


cost_for_l1_part = l_regularization_parameter/2*(vector_inside_l1_norm)'*vector_inside_l1_norm;
cost_for_differentiable_part = 0.5*(b)'*b + 0.5*(degraded_image)'*degraded_image - b'*degraded_image;

cost =  cost_for_differentiable_part + cost_for_l1_part;

% end 
