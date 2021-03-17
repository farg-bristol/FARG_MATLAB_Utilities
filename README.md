# FARG MATLAB Utilities

A collection of smaller packages and utility function to hlp with general MATLAB development

The intention of this toolbox is to:
- create a space to share smaller matlab functions/packages between researchers
- encourage a more informal sharing of matlab functions between researchers

As such the toolbox has 3 main directories:
- within the top level folder all function appear on the matlab path for easy access. such common functions (like struct2csv) complement current MATLAB functions and have little chance of masking other functions.
 - the +farg namespace structure enables common functions to not 'bloat the MATLAB namespace, reducing the risk of 'function masking'. These function can be called like so `farg.signal.psd(X,Fs)` (which incidently is a function produce the power spectial density of an input X at a smapling frequency Fs - i.e. code i imagine everyone has there own varient of....)
 - the personal namespaces such as +fh. These just act as a convient place to store your own personal functions that you dont want to explicitly share with everyone else yet, but would like to access through your own code e.g. `fh.LoadRunNumber(1234)`


I'm not sure what this repository will turn into yet, and as such I've tried to make it as inviting and flexible so that people feel happy using/contributing to it. Adding examples for you additions would be great, as would unit test but they're not essential for now....

## Getting Started

 - Make a local clone of this repository using `git clone <repositry_url_here>`. 
 - Open MATLAB and navigate to the folder where you have cloned the repository. 
 - Run the function `addsandbox` to add the package folders to the MATLAB path. 

## Running Tests
 A basic testing framwork is supplied in this template to run all of the scripts
 located in the examples folder that begin with 'example'

 To run the tests, first ensure 'addsandbox' has been run then, type `runtests('TestExamples')` 
 in the MATLAB Command Prompt and press `<Enter>`.

## Tear Down

 At the end of your development session run `rmsandbox` to remove the package folders from the MATLAB path.
