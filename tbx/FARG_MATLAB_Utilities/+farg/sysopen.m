function  sysopen(filename)
%SYSOPEN Open the file or path 'filename' outside of matlab
%   mac open copied from 
%   https://uk.mathworks.com/matlabcentral/fileexchange/42808-macopen
%
if ispc
    winopen(filename)
elseif ismac
    if strcmpi('.',filename)
        filename = pwd;
    end
    syscmd = ['open "', filename, '" &'];
    system(syscmd);
elseif isunix
    error('Unix not currently supported')
end
end

