function [bin_data] = bin(struct_a,bin_field,out_names)
x = unique([struct_a.(bin_field)]);
bin_data = struct();
for i = 1:length(x)
    idx = [struct_a.(bin_field)] == x(i);
    bin_data(i).(bin_field) = x(i);
    for j = 1:length(out_names)
        if isfield(struct_a,out_names(j))
            bin_data(i).(out_names(j)) = mean([struct_a(idx).(out_names(j))]);
        end
    end
end
end

