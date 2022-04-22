function operator_L_applied = operator_L_fun(p_matrix_pair,q_matrix_pair)

row_num = size(q_matrix_pair,1);
col_num = size(p_matrix_pair,2);
operator_L_applied = zeros(row_num,col_num);

augumented_matrix_pair_p = [zeros(1,col_num);p_matrix_pair;zeros(1,col_num)];
augumented_matrix_pair_p = [zeros(size(augumented_matrix_pair_p,1),1) augumented_matrix_pair_p];

augumented_matrix_pair_q = [zeros(row_num,1) q_matrix_pair zeros(row_num,1)];
augumented_matrix_pair_q = [zeros(1,size(augumented_matrix_pair_q,2));augumented_matrix_pair_q];

for loop_iter_row=2:row_num+1
    for loop_iter_col=2:col_num+1
        operator_L_applied(loop_iter_row-1,loop_iter_col-1) = augumented_matrix_pair_p(loop_iter_row,loop_iter_col) + augumented_matrix_pair_q(loop_iter_row,loop_iter_col) - augumented_matrix_pair_p(loop_iter_row-1,loop_iter_col) - augumented_matrix_pair_q(loop_iter_row,loop_iter_col-1);
    end
end

end