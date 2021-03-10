function modify_sandbox_path(folders, option)
%modify_sandbox_path Add/remove sandbox folders from the MATLAB path.
%
% Original code taken from the Mathworks Toolbox Tools File Exchange code:
% https://www.mathworks.com/matlabcentral/fileexchange/60070-toolbox-tools
%
% Copyright 2016 The Mathworks, Inc.
%
% Edits by Christopher Szczyglowski & James Ascham, University of Bristol, 2020

assert(iscellstr(folders), ['Expected the folders to be provided ', ...
    'as a cell-array of strings.']); %#ok<ISCLSTR>
option = validatestring(option, {'add', 'remove'});

%Construct full file paths
package_directory       = fileparts(mfilename('fullpath'));
package_sub_directories = fullfile(package_directory, folders);

%Include all subdirectories in the 'tbx' folder.
idx_tbx = contains(extractAfter(package_sub_directories, package_directory), 'tbx'); %allows for nesting
if nnz(idx_tbx) == 1
    tbx_folder = package_sub_directories{idx_tbx};
    contents = dir(tbx_folder);
    idx_directory = ...
        [contents.isdir] & ...
        ~strcmp({contents.name}, '.' ) & ...
        ~strcmp({contents.name}, '..' );
    contents = contents(idx_directory);
    tbx_sub_directories = strcat({contents.folder}, filesep, {contents.name})';
elseif nnz(idx_tbx) == 0
    tbx_sub_directories = [];
else
    error(['Ambigious match for the `tbx` directory. Expected there ', ...
        'to be only one folder in the package directory containing ', ...
        'the string `tbx`.']);
end

%Find all subdirectories in the 'dpd' folder.
idx_dpd = contains(extractAfter(package_sub_directories, package_directory), 'dpd'); %allows for nesting
if nnz(idx_dpd) == 1
    dpd_folder = package_sub_directories{idx_dpd};
    contents = dir(dpd_folder);
    idx_directory = ...
        [contents.isdir] & ...
        ~strcmp({contents.name}, '.' ) & ...
        ~strcmp({contents.name}, '..' );
    contents = contents(idx_directory);
    dpd_sub_directories = strcat({contents.folder}, filesep, {contents.name})';
elseif nnz(idx_dpd) == 0
    dpd_sub_directories = [];
else
    error(['Ambigious match for the `dpd` directory. Expected there ', ...
        'to be only one folder in the package directory containing ', ...
        'the string `dpd`.']);
end

folder_path = [package_sub_directories ; tbx_sub_directories]; %do not add dpd_sub_directories to the folder_path here


% dpd_sub_directories added to the path using dpd sandbox routine independent
% of toolbox, if not found then added to folder_path.
switch option
    case 'add'
        for i = 1:length(dpd_sub_directories)
            contents = dir(dpd_sub_directories{i});
            fnames = {contents(~[contents.isdir]).name};
            addSand = any(strcmp(fnames, 'addsandbox.m'));
            
            if addSand
                run(strcat(dpd_sub_directories{i},'\addsandbox.m'));
            else
                subfolder_path = genpath(dpd_sub_directories{i});
                folder_path = [folder_path; subfolder_path];
                warning(['No addsandbox routine in ',...
                    dpd_sub_directories{i},...
                    ': adding all to path. ',...
                    'Check to avoid conflicts.'])
            end
        end
        
    case 'remove'
        for i = 1:length(dpd_sub_directories)
            contents = dir(dpd_sub_directories{i});
            fnames = {contents(~[contents.isdir]).name};
            rmSand = any(strcmp(fnames, 'rmsandbox.m'));
            
            if rmSand
                run(strcat(dpd_sub_directories{i},'\rmsandbox.m'));
            else
                subfolder_path = genpath(dpd_sub_directories{i});
                folder_path = [folder_path; subfolder_path];
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

