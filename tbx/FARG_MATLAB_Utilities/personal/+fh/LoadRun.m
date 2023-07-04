function [d] = LoadRun(RunData,opts)
arguments
    RunData
    opts.LocalDir = '../../'
end
if iscell(RunData.Folder)
    d = load(fullfile(opts.LocalDir,RunData.Folder{:},RunData.Filename));
else
    d = load(fullfile(opts.LocalDir,RunData.Folder,RunData.Filename));
end
while isfield(d,'d')
    d = d.d;
end
end
