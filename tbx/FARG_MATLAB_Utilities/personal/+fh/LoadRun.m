function [d] = LoadRun(RunData,varargin)
%LOADRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here
p = inputParser();
p.addOptional('localDir','../../',@(x)isfolder(x))
p.parse(varargin{:});
if iscell(RunData.Folder)
    d = load(fullfile(p.Results.localDir,RunData.Folder{:},RunData.Filename));
else
    d = load(fullfile(p.Results.localDir,RunData.Folder,RunData.Filename));
end
while isfield(d,'d')
    d = d.d;
end
end
