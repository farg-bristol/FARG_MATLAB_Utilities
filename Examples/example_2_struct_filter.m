% this example will show case the structured array filtering abilities with
% the function farg.struct.filter

% first load the MetaData structure - this is a structured array of some of
% the WT tests I conducted as part of my PhD. Please have a look through
% the MetaData object to familerise yourself with it.
load(fullfile('data','MetaData.mat'),'MetaData')

%using 'farg.struct.filter' we will select runs:
% - With a massConfig 'servo_fwt'
% - At an AoA of either 5.5 or 7 degrees
% - With a runtype of either 'Steady' or 'StepInput' 
% - With a Tab Angle greater than 15 degrees absolute

%create the filter object
filt = {};
filt{1} = {'MassConfig','servo_fwt'};
filt{2} = {'AoA', [5.5,7]};
filt{3} = {'RunType',@(x)contains(x,{'Steady','StepInput'})};
filt{4} = {'TabAngle',@(x)abs(x)>15};
% the 4th and 5th filters have been defined using an anymous function, as
% such it is easy to see how extensible this method can be...

%filter the array
filtedMeta = farg.struct.filter(MetaData,filt);

%by inspecting filteredMeta Data you can see hwo the filters have been
%applied.
assert(length(filtedMeta)==17);
