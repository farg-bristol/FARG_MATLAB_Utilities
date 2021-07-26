function [d] = LoadRunNumber(runNumber,varargin)
%LOADRUNNUMBER load data from a specific run
%   Load data from run 'runNumber'
%   Parameters:
%       - localDir: path to folder containing data folder (default ../..)

p = inputParser();
p.addOptional('localDir','../../',@(x)isfolder(x))
p.parse(varargin{:});

load(fullfile(p.Results.localDir,'..','MetaData.mat'),'MetaData')

ind = find([MetaData.RunNumber] == runNumber,1);

d = fh.LoadRun(MetaData(ind),varargin{:});
end
