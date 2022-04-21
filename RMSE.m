function return_val = PSNR_ratio(first_image,second_image,maximum_pixel_intensity)

if nargin == 2
    if max(max(first_image)) > 10
        maximum_pixel_intensity = 255;
    else
        maximum_pixel_intensity = 1;
    end
end

mean_square_error = sum((first_image(:)-second_image(:)).^2) / numel(first_image);
rmean_square_error = sqrt(mean_square_error);
return_val = rmean_square_error;



% end 