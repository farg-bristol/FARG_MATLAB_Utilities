function [struct_a] = merge(struct_a,struct_b)
%%if one of the structres is empty do not merge
if length(struct_a) ~= length(struct_b)
    error('structures must have same length')
end
f = fieldnames(struct_b);
for j=1:length(struct_a) 
    for i = 1:length(f)
        struct_a(j).(f{i}) = struct_b(j).(f{i});
    end
end