function return_evaluated_val = operator_total_variation_eval( input_image )


[matrix_pair_p, matrix_pair_q]=operator_L_adjoint_2(input_image);

return_evaluated_val = sum(sum(abs(matrix_pair_p)))+sum(sum(abs(matrix_pair_q)));

end

