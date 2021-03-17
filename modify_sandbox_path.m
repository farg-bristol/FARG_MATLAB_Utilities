function modify_sandbox_path(folders, option)
%modify_sandbox_path Add/remove sandbox folders from the MATLAB path.
%
% Original code taken from the Mathworks Toolbox Tools File Exchange code:
% https://www.mathworks.com/matlabcentral/fileexchange/60070-toolbox-tools
%
% Copyright 2016 The Mathworks, Inc.
%
% Edits by Christopher Szczyglowski & James Ascham, University of Bristol, 2020
% Edits by Fintan Healy, University of Bristol, 2021

assert(iscellstr(folders), ['Expected the folders to be provided ', ...
    'as a cell-array of strings.']); %#ok<ISCLSTR>
option = validatestring(option, {'add', 'remove'});

%Construct full file paths
package_directory       = fileparts(mfilename('fullpath'));
package_sub_directories = fullfile(package_directory, folders);

%Include all subdirectories in the 'tbx' folder.
if isfolder(fullfile(package_directory,'tbx'))
    tbx_sub_directories = get_sub_folders(fullfile(package_directory,'tbx'));
else
    tbx_sub_directories = [];
end

folder_path = [package_sub_directories ; tbx_sub_directories]; %do not add dpd_sub_directories to the folder_path here


% dpd_sub_directories added to the path using dpd sandbox routine independent
% of toolbox, if not found then added to folder_path.
if isfolder(fullfile(package_directory,'dpd'))
    switch option
        case 'add'
            dpd_sub_directories = dir(fullfile(folderpath,"dpd",'*','addsandbox.m'));
            for i = 1:length(dpd_sub_directories)
                run(dpd_sub_directories(i));
            end

        case 'remove'
            dpd_sub_directories = dir(fullfile(folderpath,"dpd",'*','rmsandbox.m'));
            for i = 1:length(dpd_sub_directories)
                run(dpd_sub_directories(i));
            end
    end
end

% Capture path
oldPathList = path();

% Add toolbox directory to saved path
userPathList = userpath();
if isempty( userPathList )
    userPathCell = cell( [0 1] );
else
    userPathCell = textscan( userPathList, '%s', 'Delimiter', ';' );
    userPathCell = userPathCell{:};
end
savedPathList = pathdef();
savedPathCell = textscan( savedPathList, '%s', 'Delimiter', ';' );
savedPathCell = savedPathCell{:};
savedPathCell = setdiff( savedPathCell, userPathCell, 'stable' );

switch option
    case 'add'
        
        savedPathCell = [folder_path; savedPathCell];
        path_fcn = @addpath;
        
    case 'remove'
        
        savedPathCell = setdiff( savedPathCell, folder_path, 'stable' );
        path_fcn = @rmpath;
        
end

path( sprintf( '%s;', userPathCell{:}, savedPathCell{:} ) )
savepath()

% Restore path plus toolbox directory
path( oldPathList )
path_fcn( sprintf( '%s;', folder_path{:} ) )

end


function folders = get_sub_folders(folderpath)
    % find all files in the directory
    files = dir(fullfile(folderpath,'**'));
    % extract all unique folders not in a namespace convention
    folders = arrayfun(@(x)string(strsplit(x.folder,[filesep,'+'])),...
        files,'UniformOutput',false);
    folders = unique(cellfun(@(x)x(1),folders));
    % remove origanal fold from results
    folders = folders(~strcmp(folders,folderpath));
end

