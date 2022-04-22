
%this script solves the optimization problem  for denoising the image
% i.e. min_x ||x-b||_2^2 + 2*lambda*TV(x)

%doing necessary errands
    clear;
    close all;
    clc;



    % load the image

    %assuming image to be grayscale

    input_image_original = imread('cameraman.pgm');
    %if image is RGB, convert to grayscale
%     input_image_grayscale = im2gray(input_image_original);
    input_image_grayscale = double(input_image_original);
%     input_image_grayscale = double(rgb2gray(input_image_original));

%converting to normalized range [0,1]

    input_image_grayscale_normalized = input_image_grayscale./255;

    %adding the noise to the image
    noise_level = 0.1;
    %noise image to be added to our image
    % noise_image = randn(size(input_image_grayscale_normalized))*noise_level;
    %add noise to the image of zero mean and standard deviation of 0.1
    input_image_grayscale_noisy = imnoise(input_image_grayscale_normalized,'gaussian',0,noise_level);
    
    vector_b = input_image_grayscale_noisy;    %noisy observed image


    %setting the parameter struct for the algorithm 
    %struct parameters
    param.number_of_iterations = 30;
    param.lambda_l = 0.1;
    param.image_lower_bound = 0;
    param.image_upper_bound = 1;

   
 
    [GP_image,GP_unc, GP_return_param] = GP(vector_b, param, input_image_grayscale_normalized);

    [FGP_image,FGP_unc, FGP_return_param] = FGP(vector_b, param, input_image_grayscale_normalized);
    
%% Plotting the findings

%making the image matrix again out of the current matrix by rescaling

%plotting ALL 4 IMAGES in a figure for comparison

% plotting the original image
%again converting the imagees to range 0-255 from range 0-1
original_image_for_plot = input_image_grayscale_normalized*255;
%converting to uint
original_image_for_plot = uint8(original_image_for_plot);
%making input_image_grayscale_noisy to be in range 0-255
input_image_grayscale_noisy = uint8(input_image_grayscale_noisy*255);
%making GP_image and FGP_image to be in range 0-255
GP_image = GP_image*255;
GP_image = uint8(GP_image);
FGP_image = FGP_image*255;
FGP_image = uint8(FGP_image);
imshow(GP_image)
% imshow(original_image_for_plot);

% title('Original Image');
subplot(1,4,1);
imshow(original_image_for_plot);
title('Original Image');

subplot(1,4,2);
imshow(input_image_grayscale_noisy);
title('Noisy Image');

subplot(1,4,3);
imshow(GP_image);
title('GP');

subplot(1,4,4);
imshow(FGP_image);
title('FGP');




%now plotting the graphs for the cost function vs iteration of both algorithms
figure('Position',[400,400,200,200]),plot(1:length(GP_return_param.function_value),GP_return_param.function_value,'r',1:length(FGP_return_param.function_value),FGP_return_param.function_value,'b');title('Function Value vs Iteration');legend('GP','FGP');

%now relative_difference_value vs iteration of both algorithms
figure('Position',[400,400,200,200]),plot(1:length(GP_return_param.relative_difference_value),GP_return_param.relative_difference_value,'r',1:length(FGP_return_param.relative_difference_value),FGP_return_param.relative_difference_value,'b');title('Relative Difference Value vs Iteration');legend('GP','FGP');

%now function_error
figure('Position',[400,400,200,200]),plot(1:length(GP_return_param.function_error),GP_return_param.function_error,'r',1:length(FGP_return_param.function_error),FGP_return_param.function_error,'b');title('f(x_k) - f_converge');legend('GP','FGP');

%now distance_from_minima
% figure('Position',[400,400,200,200]),plot(1:length(GP_return_param.distance_from_minima),GP_return_param.distance_from_minima,'r',1:length(FGP_return_param.distance_from_minima),FGP_return_param.distance_from_minima,'b');title('f(x_k) - f* vs Iteration');legend('GP','FGP');


%now psnr_value vs iteration of both algorithms
figure('Position',[400,400,200,200]),plot(1:length(GP_return_param.psnr_value),GP_return_param.psnr_value,'r',1:length(FGP_return_param.psnr_value),FGP_return_param.psnr_value,'b');title('PSNR Value vs Iteration');legend('GP','FGP');

%now mse_value vs iteration of both algorithms
figure('Position',[400,400,200,200]),plot(1:length(GP_return_param.mse_value),GP_return_param.mse_value,'r',1:length(FGP_return_param.mse_value),FGP_return_param.mse_value,'b');title('RMSE Value vs Iteration');legend('GP','FGP');











% %now in a new figure , plot the metrics that are stored in the struct GP_return_param and FGP_return_param

% %pllotting function value array of both algorithms in same plot
% figure;
% plot(GP_return_param.function_value);
% hold on;
% plot(FGP_return_param.function_value);
% title('Function value ');
% legend('GP','FGP');


% %plotting psnr_value of both algorithms in same plot
% figure;
% plot(GP_return_param.psnr_value);
% hold on;
% plot(FGP_return_param.psnr_value);
% title('PSNR value ');
% legend('GP','FGP');

% %plotting rmse_value of both algorithms in same plot
% figure;
% plot(GP_return_param.rmse_value);
% hold on;
% plot(FGP_return_param.rmse_value);
% title('RMSE value ');
% legend('GP','FGP');

% %plotting relative_difference_value of both algorithms in same plot
% figure;
% plot(GP_return_param.relative_difference_value);
% hold on;
% plot(FGP_return_param.relative_difference_value);
% title('Relative Difference value ');
% legend('GP','FGP');







   
    