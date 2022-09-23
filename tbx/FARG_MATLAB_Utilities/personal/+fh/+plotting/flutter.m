function pl = flutter(data,opts)
arguments
    data
    opts.filter = {};
    opts.NModes = NaN;
    opts.LineStyle = '-';
    opts.LineWidth = 1.5;
    opts.DisplayName = [];
    opts.Mode = 'MODE';
    opts.XAxis = 'V';
    opts.YAxis = 'F';
    opts.YScaling = @(x)x;
    opts.Colors = [1,0,0;0,0,1;0,1,1;0,1,0;1,1,0;1,0,1];
end
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
data = farg.struct.filter(data,opts.filter);

if isempty(opts.NModes)||isnan(opts.NModes)
    opts.NModes = max([data.(opts.Mode)]);
end
for i = 1:opts.NModes
    mode_ind = [data.(opts.Mode)] == i;

    mode_data = data(mode_ind);
    if ~isempty(mode_data)
        %sort the XAxis
        [~,idx] = sort([mode_data.(opts.XAxis)]);
        mode_data = mode_data(idx);
        x = [mode_data.(opts.XAxis)];
        y = opts.YScaling([mode_data.(opts.YAxis)]);
        pl(i) = plot(x,y,opts.LineStyle);
        pl(i).Color = opts.Colors(mod(i-1,size(opts.Colors,1))+1,:);
        pl(i).LineWidth = opts.LineWidth;
        if ~isempty(opts.DisplayName)
            pl(i).DisplayName = [opts.DisplayName,' ',num2str(i)];
        else
            pl(i).Annotation.LegendInformation.IconDisplayStyle = 'off';
        end
        hold on
    end
end
end