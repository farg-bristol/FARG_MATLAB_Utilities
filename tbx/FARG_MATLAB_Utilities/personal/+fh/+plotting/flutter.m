function flutter(data,varargin)
%PLOT_FLUTTER method to easily plot flutter data
% Inputs:
%   - data: a structured array with the following fields:
%       - <Mode>: the mode number
%       - <XAxis>: the name in the parameter XAxis (defualt = V)
%       - <YAxis>: the name in the parameter YAxis (defualt = F)
% Optional Parameters:
%   - filter: a function which return the filtered indicies of data to use
%   - scale: a function to scale the Y values by 
%   - NModes: max mode number to plot
%   - LineStyle:
%   - LineWidth:
%   - Display Name: appened ifront of each mode
%   - Mode: field in data speicifing mode numbers (default MODE)
%   - XAxis: field in data to plot on x axis (default V)
%   - YAxis: field in data to plot on y axis (default F)
%   - Colors: nx3 matrix of colors to plot
%
p = inputParser();
p.addParameter('filter',@(x)logical(ones(length(x),1)))
p.addParameter('scale',@(x)x)
p.addParameter('NModes',[])
p.addParameter('LineStyle','-')
p.addParameter('DisplayName',[])
p.addParameter('LineWidth',1)
p.addParameter('Mode','MODE');
p.addParameter('XAxis','V');
p.addParameter('YAxis','F');
p.addParameter('Colors',[1,0,0;0,0,1;0,1,1;0,1,0;1,1,0;1,0,1])
p.parse(varargin{:})

data = data(p.Results.filter(data));

if isempty(p.Results.NModes)
    p.parse('NModes',max([data.(p.Results.Mode)]),varargin{:})
end
for i = 1:p.Results.NModes
    mode_ind = [data.(p.Results.Mode)] == i;
    mode_data = data(mode_ind);
    %sort the XAxis
    [~,idx] = sort([mode_data.(p.Results.XAxis)]);
    mode_data = mode_data(idx);
    pl = plot([mode_data.(p.Results.XAxis)],...
        p.Results.scale([mode_data.(p.Results.YAxis)]),...
        p.Results.LineStyle);
    pl.Color = p.Results.Colors(mod(i-1,length(p.Results.Colors))+1,:);
    pl.LineWidth = p.Results.LineWidth;
    if ~isempty(p.Results.DisplayName)
        pl.DisplayName = [p.Results.DisplayName,' ',num2str(i)];
    else
        pl.Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    hold on
end
end