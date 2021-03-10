classdef TestExamples < matlab.unittest.TestCase
    %Test_NonlinearShapeFunctions Runs the test cases for the 
    
    properties (TestParameter)
        %List of files in ../examples/ that start with "example"
        ExampleBasedTest = getExampleScripts;
    end
    
    %   - examples
%     methods (TestMethodSetup)
%         function create_figures(obj)
%             obj.TestFigure = figure('Name', 'MyTestFigure');
%         end
%     end
    methods (Test)
        function example_run_example_scripts(~, ExampleBasedTest)
            %runExamples Attempts to run each of the example files in the
            %'../examples/' directory.
                        
            run(ExampleBasedTest);
            
        end
    end
    methods (TestMethodTeardown)
        function remove_figures(~)
            hFigure = findobj(0, 'Type', 'Figure');
            close(hFigure);
        end
    end
end

%Generating parametric test inputs
function example_files = getExampleScripts
%getExampleScripts Returns a cell-array containing the full file path to
%the example scripts in the '\tbx\AwiWttToolbox\workflow' folder.

tbx_path    = fileparts(fileparts(mfilename('fullpath')));
example_loc = fullfile(tbx_path, 'examples');

%What is in the folder?
contents = dir(example_loc);
ext = cell(1, numel(contents));
for ii = 1 : numel(contents)
    [~, ~, ext{ii}] = fileparts(contents(ii).name);
end

%Only retain '.m' files
contents = contents(ismember(ext, '.m'));

%Only retain files that begin with 'example'
contents      = contents(startsWith({contents.name}, 'example'));
example_files = fullfile(example_loc, {contents.name});

end

