function [x_star,func, return_param] = FGP(vector_b, param, original_image)



    %measuring time
    tic;

    fprintf('*MFISTA based denoising\n');
    
    fprintf('#iter_count  objective_function f(xk -x_{k-1})/f(x_{k-1}))\n');
    
    
    %initialization
    
    epsilon_to_stop_the_loop = 1e-4;
    
    [num_rows,num_cols] = size(vector_b);
    gradient_matrix = zeros(num_rows,num_cols);
    p__matrix_pair = zeros(num_rows-1,num_cols);
    q__matrix_pair = zeros(num_rows,num_cols-1);
    p_matrix_pair_minus_1 = p__matrix_pair;
    q_matrix_pair_minus_1 = q__matrix_pair;
    
    %for storing purposes
    
    function_value = 0;
    psnr_value = 0;
    mse_value = 0;
    relative_difference_value = 0;
    function_error = 0;
    
    distance_from_minima = 0;

    %true minima
    function_minima = norm(original_image - vector_b ,'fro') + 2 * param.lambda_l * operator_total_variation_eval(original_image);
    



t_k_minus_1 = 1;


%implementing FGP

for looping_variable=1:param.number_of_iterations
    constant_temp= (1/(8*param.lambda_l )) %this is the constant used in used after applying the L adjoint operaor
    
    %calculating the gradient
    Lipschitz_constant_p_q_pair = operator_L(p_matrix_pair_minus_1,q_matrix_pair_minus_1);

    %
    Lipschitz_constant_b = vector_b - param.lambda_l *Lipschitz_constant_p_q_pair;
    % calculating projection
    projection_of_vector_b = operator_projection_on_set_C(Lipschitz_constant_b, param.image_upper_bound, param.image_lower_bound);
    %
    [Adjoint_L_operaotr_on_p, Adjoint_L_operaotr_on_q] = operator_L_Adjoint(projection_of_vector_b);
    
    r_k = p_matrix_pair_minus_1 + constant_temp*Adjoint_L_operaotr_on_p;
    s_k = q_matrix_pair_minus_1 + constant_temp*Adjoint_L_operaotr_on_q;
    [p_iter_k,q_iter_k] = operator_project_pp(r_k,s_k);     %eq  4.9 of paper


    t_k_plus_1 = (1 + sqrt(1 + 4*t_k_minus_1^2))/2;             %eq 4.10 of paper


    
    p_matrix_pair_minus_1 = p_iter_k + ((t_k_minus_1-1)/(t_k_plus_1))*(p_iter_k - p_matrix_pair_minus_1);
    q_matrix_pair_minus_1 = q_iter_k + ((t_k_minus_1-1)/(t_k_plus_1))*(q_iter_k - q_matrix_pair_minus_1);
    t_k_minus_1 = t_k_plus_1;
    prev_step_gradient = gradient_matrix;

    gradient_matrix = projection_of_vector_b;

    func.value(looping_variable) = -norm(Lipschitz_constant_b - projection_of_vector_b ,'fro')^2 + norm(Lipschitz_constant_b,'fro')^2;
    function_value = [function_value;func.value(looping_variable)];

%calculating true minima
  %function true minima value
  Lipschitz_constant_true = original_image - param.lambda_l *Lipschitz_constant_p_q_pair;
  projection_of_true_image = operator_projection_on_set_C(Lipschitz_constant_true, param.image_upper_bound, param.image_lower_bound);
  func.true_minima(looping_variable) = -norm(Lipschitz_constant_true - projection_of_true_image ,'fro')^2 + norm(Lipschitz_constant_true,'fro')^2;
  %relative difference
  function_error = [function_error;func.value(looping_variable) - func.true_minima(looping_variable) ];

  distance_from_minima = [distance_from_minima;(func.value(looping_variable) - func.true_minima(looping_variable))];

    func.relative_difference(looping_variable) = norm(gradient_matrix - prev_step_gradient,'fro')/norm(gradient_matrix,'fro');
    relative_difference_value = [relative_difference_value;func.relative_difference(looping_variable)];


    %storing the psnr
    func.psnr(looping_variable) = PSNR_ratio(original_image(:),projection_of_vector_b);
    psnr_value = [psnr_value;func.psnr(looping_variable)];
    %MSE
    func.mse(looping_variable) = RMSE(original_image(:),projection_of_vector_b);
    mse_value = [mse_value;func.mse(looping_variable)];

    
        if looping_variable>5 && func.relative_difference(looping_variable) <= epsilon_to_stop_the_loop
        break;
    end
end
%eq 4.11 of paper
x_star = operator_projection_on_set_C(vector_b -  param.lambda_l*operator_L(p_matrix_pair_minus_1,q_matrix_pair_minus_1), param.image_upper_bound, param.image_lower_bound);
func.time = toc;


%putting all the metrics in a struct

return_param.function_value = function_value;
return_param.psnr_value = psnr_value;
return_param.mse_value = mse_value;
return_param.relative_difference_value = relative_difference_value;
return_param.function_error = function_error;
return_param.distance_from_minima = distance_from_minima;



end