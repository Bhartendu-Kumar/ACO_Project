function [output_image, cost_function_per_iter  , RMSE_per_iter , PSNR_per_iter] = ISTA(actual_image, A,b,x_initial,argument_struct, A_function)



%unpacking the parameters from the argument structure

%
to_use_fista = argument_struct.to_use_fista;
to_show = argument_struct.to_show;
l_regularization_parameter = argument_struct.l_regularization_parameter;
number_of_iterations = argument_struct.number_of_iterations;
tolerance_epsilon = argument_struct.tolerance_epsilon;

parameter_for_linesearch = argument_struct.parameter_for_linesearch ;
to_use_linesearch = argument_struct.to_use_linesearch ;  
objective_function=argument_struct.objective_function ;
gradient_function = argument_struct.gradient_function ;
hessian_function = argument_struct.hessian_function ;




%initializing variables


A_transpose_A = A'*A;
%getting the Lipschitz constant
Lipschitz = max(eig(A_transpose_A));
l_inv = 1/Lipschitz;



%initializing
x_iter_k = x_initial;



cost_of_objective_function_given_x  = func(x_initial,b,A,l_regularization_parameter);


%building the variables to store cost function, RMSE, PSNR


cost_function_per_iter = cost_of_objective_function_given_x;
RMSE_per_iter = RMSE(actual_image, x_iter_k);
PSNR_per_iter = PSNR_ratio(actual_image, x_iter_k);




fprintf('%6s %9s %9s\n','iteration Count','Cost Function');
fprintf('%6i %9.2e %9.2e\n',0,cost_of_objective_function_given_x);
%starting the timer
tic;

%loop iteration for optimizing the cost function
for loop_count = 1:number_of_iterations
    %initialize variables
    x_iter_k_minus_1 = x_iter_k;
    
    degraded_image_vector = x_iter_k - l_inv*(A_transpose_A*x_iter_k-A'*b); 
    
    x_iter_k = subplus(abs(degraded_image_vector)-l_regularization_parameter/Lipschitz) .* sign(degraded_image_vector); % shrinkage operation

       %to update the 3 variables to compare the iteration performance
       cost_function_per_iter = [cost_function_per_iter; func(x_iter_k,b,A,l_regularization_parameter)];
       RMSE_per_iter = [RMSE_per_iter ; RMSE(actual_image, x_iter_k)];
       PSNR_per_iter = [PSNR_per_iter ; PSNR_ratio(actual_image, x_iter_k)];
       
    if to_show > 0
        fprintf('%6i %9.2e %9.2e\n',loop_count,func(x_iter_k,b,A,l_regularization_parameter));
    end
    if norm(x_iter_k-x_iter_k_minus_1)/norm(x_iter_k_minus_1) < tolerance_epsilon
        fprintf('%6i %9.2e %9.2e\n',loop_count,func(x_iter_k,b,A,l_regularization_parameter));
        fprintf('  converged at %dth iterations\n',loop_count);
        break;
    end


end
toc;

% update return value
output_image = x_iter_k;



function cost_of_objective_function_given_x = func(x_iter_k,b,A,l_regularization_parameter)
    x_hat = b - A*x_iter_k;
cost_of_objective_function_given_x = 0.5*(x_hat)'*x_hat + l_regularization_parameter*sum(abs(x_iter_k));



% end 