function [d] = LoadRunNumber(runNumber,varargin)
%LOADRUNNUMBER Summary of this function goes here
%   Detailed explanation goes here

p = inputParser();
p.addOptional('localDir','../../',@(x)isfolder(x))
p.parse(varargin{:});

load(fullfile(p.Results.localDir,'..','MetaData.mat'),'MetaData')

ind = find([MetaData.RunNumber] == runNumber,1);

d = fh.LoadRun(MetaData(ind),varargin{:});
end
