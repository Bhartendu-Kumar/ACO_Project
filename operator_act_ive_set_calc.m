function [new_val_M, new_val_grad] = operator_act_ive_set_calc(input_vector, parameter_l, gradient_of_input_vector)
tolerance_epsilon = 10^-5;

M = (input_vector == -parameter_l & gradient_of_input_vector > tolerance_epsilon) |...
    (input_vector == parameter_l & gradient_of_input_vector < -tolerance_epsilon);
new_val_M = not(M);
new_val_grad = gradient_of_input_vector(new_val_M);
end