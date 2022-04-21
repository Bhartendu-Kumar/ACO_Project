function [argument_struct] = building_calling_parameters(fun_obj ,c_constrained_ls )


    %this function just builds the parameters for the calling of the ISTA/FISTA

    argument_struct.parameter_for_linesearch = 0.5;
    argument_struct.to_use_linesearch = 1;        % 1 for linesearch, 2 for backtracking


    argument_struct.number_of_iterations = 100;   %100  , 1000
    argument_struct.l_regularization_parameter = 0.01;
    argument_struct.tolerance_epsilon =  10^(-5);   %epsilon error in cost function allowed =10^(-5)

    argument_struct.objective_function = @objective_function_l1;
    argument_struct.gradient_function = @gradient_function_l1_grad;
    argument_struct.hessian_function = @hessian_function_l1_hessian;

    argument_struct.to_use_fista = 2        %valid optionss are 1 and 2
    argument_struct.constrained_least_square = c_constrained_ls;

    argument_struct.to_show = 0;  % 0 , 1 , 2 are the options , 0 by default , 1 showing log values, 2 plots figure and shows values too