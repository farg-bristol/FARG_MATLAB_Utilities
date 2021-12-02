function namestr = getobjname(varargin)
% returns the name of 'obj' as a string
namestr = {};
n = nargin;
if n>0
    for i = 1:n
        namestr{i} = inputname(i);
    end
end
namestr = convertCharsToStrings(namestr);
end

