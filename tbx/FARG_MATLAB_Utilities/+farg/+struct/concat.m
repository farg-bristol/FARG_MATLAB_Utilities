function [S1] = concat(S1,S2,varargin)
%CONCAT concatonates two structures with disimilar fields
% S2 is added to the end of S1, if a field in S2 exists in S1 they are
% combined, otherwise a new field is created (and all the values in S1 
% are set blank)
%
% created:  11/03/2021
% author:   Fintan Healy
% email:    fintan.healy@bristol.ac.uk
%
fields = fieldnames(S2);
n = length(S1);
ind = 0;
for i = 1:length(S2)
    ind = ind +1;
    for j = 1:numel(fields)
        S1(n+ind).(fields{j}) = S2(ind).(fields{j});        
    end
end
for i = 1:length(varargin)
    S1 = farg.struct.concat(S1,varargin{i});
end

end

