function [ matrix_pair_p, matrix_pair_q ] = operator_L_adjoint_2( input_image )


[rows, colns] = size(input_image);

matrix_pair_p = input_image(1:rows-1, :) - input_image(2:rows, :);
matrix_pair_q = input_image(:,1:colns-1) - input_image(:, 2:colns);
end

