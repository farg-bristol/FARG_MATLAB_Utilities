function [d] = LoadRun(RunData,varargin)
%LOADRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here
p = inputParser();
p.addOptional('localDir','../../',@(x)isfolder(x))
p.parse(varargin{:});

d = load(fullfile(p.Results.localDir,RunData.Folder,RunData.Filename));
end
