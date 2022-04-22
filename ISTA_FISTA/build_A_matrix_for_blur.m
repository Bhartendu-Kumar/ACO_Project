function [A,blur_kernel_two_dim] = build_A_matrix_for_blur(image_two_dim,initial_blur_kernal_two_dim)

% we will create the Matrix A for the blur problem , where A is the matrix in the cost function:

% \begin{equation}
% \hat{x} = argmin_x { || Ax - b ||^2 + \lambda ||x||_1 } 
% \end{equation}

% we will build this A when we are given the kernel for blurring



disp('creating Matrix A for blur problem');

[row,col] = size(image_two_dim);


%%% we will create the blur kernel matrix


    [row_m, col_n ] = size(image_two_dim);
    A1 = zeros(row_m,col_n);
    [row_A, col_A ] = size(initial_blur_kernal_two_dim);
    A1(1:row_A,1:col_A) = initial_blur_kernal_two_dim;
    blur_kernel_two_dim = circshift(A1,[-floor(row_A/2),-floor(col_A/2)]);
 %%



A_row = zeros(row,row*col);
for i=0:row-1
    blur_kernel_two_dim_shift = circshift(blur_kernel_two_dim,[i,0]);
    A_row(i+1,:) = blur_kernel_two_dim_shift(:)';
end
for j=0:col-1
    A_row_shift = circshift(A_row,[0,j*row]);
    A(j*row+1:(j+1)*row,:) = A_row_shift;
end