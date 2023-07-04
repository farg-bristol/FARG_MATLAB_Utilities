function [d] = LoadRunNumber(runNumber,opts)
arguments
    runNumber
    opts.metaFile = 'MetaData.mat'
    opts.LocalDir = '../../'
end
%LOADRUNNUMBER load data from a specific run
%   Load data from run 'runNumber'
%   Parameters:
%       - localDir: path to folder containing data folder (default ../..)

load(fullfile(opts.LocalDir,'..',opts.metaFile),'MetaData')

ind = find([MetaData.RunNumber] == runNumber,1);

d = fh.LoadRun(MetaData(ind),"LocalDir",opts.LocalDir);
end
