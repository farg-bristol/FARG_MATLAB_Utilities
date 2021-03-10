# MATLAB Toolbox Template

A template folder structure to standardise MATLAB toolbox generation

## Getting Started

 - Fork this repository 
 - Make a local clone of your fork using `git clone <repositry_url_here>`. 
 - Open MATLAB and navigate to the folder where you have cloned the repository. 
 - Run the function `addsandbox` to add the package folders to the MATLAB path. 

## Running Tests
 A basic testing framwork is supplied in this template to run all of the scripts
 located in the examples folder that begin with 'example'

 To run the tests, first ensure 'addsandbox' has been run then, type `runtests('TestExamples')` 
 in the MATLAB Command Prompt and press `<Enter>`.

## Tear Down

 At the end of your development session run `rmsandbox` to remove the package folders from the MATLAB path.
