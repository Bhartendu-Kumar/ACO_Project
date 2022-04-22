function projected_value = operator_projection_on_set_C(input_to_be_projected, upper_bound, lower_bound)

[num_rows,num_cols] = size(input_to_be_projected);
projected_value = zeros(size(input_to_be_projected));
for row=1:num_rows
    for col=1:num_cols
        if (input_to_be_projected(row,col) <= upper_bound) && (lower_bound <= input_to_be_projected(row,col))
            projected_value(row,col) = input_to_be_projected(row,col);
        elseif (input_to_be_projected(row,col) < lower_bound)
            projected_value(row,col) = lower_bound;
        elseif (upper_bound < input_to_be_projected(row,col))
            projected_value(row,col) = upper_bound;
        end
    end
end

end