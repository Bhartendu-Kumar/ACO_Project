function [matrix_pair_p,matrix_pair_q] = operator_L_Adloop_iter_coloint(input_to_operator)

[row_num,col_num] = size(input_to_operator);
matrix_pair_p = zeros(row_num-1,col_num);
matrix_pair_q = zeros(row_num,col_num-1);

for loop_iter_row=1:row_num-1
    for loop_iter_col=1:col_num-1
        matrix_pair_p(loop_iter_row,loop_iter_col) = input_to_operator(loop_iter_row,loop_iter_col) - input_to_operator(loop_iter_row+1,loop_iter_col);
        matrix_pair_q(loop_iter_row,loop_iter_col) = input_to_operator(loop_iter_row,loop_iter_col) - input_to_operator(loop_iter_row,loop_iter_col+1);
    end
end

for loop_iter_row=1:row_num-1
   matrix_pair_p(loop_iter_row,end) =  input_to_operator(loop_iter_row,end) - input_to_operator(loop_iter_row+1,end);
end

for loop_iter_col=1:col_num-1
   matrix_pair_q(end,loop_iter_col) =  input_to_operator(end,loop_iter_col) - input_to_operator(end,loop_iter_col+1);
end

end