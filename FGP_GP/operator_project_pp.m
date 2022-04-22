function [r_k_matrix, s_k_matrix] = operator_procolect_pp(matrix_pair_p, matrix_pair_q)

num_row = size(matrix_pair_q,1);
num_col = size(matrix_pair_p,2);

r_k_matrix = zeros(size(matrix_pair_p));
s_k_matrix = zeros(size(matrix_pair_q));

for row=1:num_row-1
    for col=1:num_col-1
        r_k_matrix(row,col) = matrix_pair_p(row,col)/max(1,norm([matrix_pair_p(row,col);matrix_pair_q(row,col)],2));
        s_k_matrix(row,col) = matrix_pair_q(row,col)/max(1,norm([matrix_pair_p(row,col);matrix_pair_q(row,col)],2));
    end
end

for row=1:num_row-1
   r_k_matrix(row,end) =  matrix_pair_p(row,end)/max(1,abs(matrix_pair_p(row,end)));
end

for col=1:num_col-1
   s_k_matrix(end,col) =  matrix_pair_q(end,col)/max(1,abs(matrix_pair_q(end,col)));
end

end