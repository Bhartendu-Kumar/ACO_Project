function [output_image,cost_function_per_iter  , RMSE_per_iter , PSNR_per_iter] = FISTA(actual_image,A,b,x_initial,argument_struct,hfun)




% we will store 3 things in each iteration
%1. cost function 
%2. RMSE (Root Mean Square Error)
%3. PSNR (Peak Signal to Noise Ratio)



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
Lipschitz = max(eig(A_transpose_A ));
l_inv = 1/Lipschitz;

%to calculate t at current iteration
if to_use_fista == 1
    t_iter_k = 1;
end




cost_of_objective_function_given_x = func(x_initial,b,A,l_regularization_parameter);

x_iter_k = x_initial;

b_iter_k = x_iter_k;


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
    b_iter_k_minus_1 = b_iter_k;

    %if we are using ISTA, keep t_k constant
    if to_use_fista == 1
        t_iter_k_minus_1 = t_iter_k;
    end

    degraded_image_vector = b_iter_k_minus_1 - l_inv*(A_transpose_A*b_iter_k_minus_1-A'*b); 
   
    x_iter_k = subplus(abs(degraded_image_vector)-l_regularization_parameter/Lipschitz) .* sign(degraded_image_vector); % shrinkage operation
    
    %calculate t_k+1 in Fista
    if to_use_fista == 1
        t_iter_k = (1+sqrt(1+4*t_iter_k_minus_1*t_iter_k_minus_1))/2;
        b_iter_k = x_iter_k + (t_iter_k_minus_1-1)/t_iter_k*(x_iter_k-x_iter_k_minus_1);
    %if ISTA leave it same 
    elseif to_use_fista == 2
        b_iter_k = x_iter_k + loop_count/(loop_count+3) * (x_iter_k-x_iter_k_minus_1);
    end

    %to update the 3 variables to compare the iteration performance
    cost_function_per_iter = [cost_function_per_iter; func(x_iter_k,b,A,l_regularization_parameter)];
    RMSE_per_iter = [RMSE_per_iter ; RMSE(actual_image, x_iter_k)];
    PSNR_per_iter = [PSNR_per_iter ; PSNR_ratio(actual_image, x_iter_k)];



    if to_show > 0
        fprintf('%6i %9.2e %9.2e\n',loop_count,func(x_iter_k,b,A,l_regularization_parameter));
    end

    if norm(x_iter_k-x_iter_k_minus_1)/norm(x_iter_k_minus_1) < tolerance_epsilon
        fprintf('%6i %9.2e %9.2e\n',loop_count,func(x_iter_k,b,A,l_regularization_parameter));
        fprintf('  convergence attained at iterations = %d\n',loop_count);
        break;
    end


end

toc;

% update return value
output_image = x_iter_k;


function cost_of_objective_function_given_x= func(x_iter_k,b,A,l_regularization_parameter)
x_hat = b - A*x_iter_k;
cost_of_objective_function_given_x= 0.5*(x_hat)'*x_hat + l_regularization_parameter*sum(abs(x_iter_k));


% end 