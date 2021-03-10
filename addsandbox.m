function addsandbox()
%addsandbox  Install sandbox
%
%  See also: rmsandbox, 
%            modify_sandbox_path
%
%  Copyright 2016 The MathWorks, Inc.
%
% Edits by Christopher Szczyglowski, University of Bristol, 2020
%   - Refactored most of the code into 'modify_sandbox_path'

sub_directory_to_add = {'tbx' ; 'tests' ; 'examples'};
modify_sandbox_path(sub_directory_to_add, 'add');

end 