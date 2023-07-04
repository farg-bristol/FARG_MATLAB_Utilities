function pl = flutter(data,opts,pltOpts)
arguments
    data
    opts.filter = {}
    opts.NModes = []
    opts.XAxis = 'V'
    opts.YAxis = 'F'
    opts.Mode = 'MODE'
    opts.YScaling = @(x)x
    opts.Colors = [1,0,0;0,0,1;0,1,1;0,1,0;1,1,0;1,0,1]
    opts.DisplayName = []

    pltOpts.LineStyle = '-';
    pltOpts.Marker = '.';
    pltOpts.LineWidth = 1
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
if ~isempty(opts.filter)
    data = farg.struct.filter(data,opts.filter);
end

if isempty(opts.NModes)
    opts.NModes = 1:max([data.(opts.Mode)]);
elseif length(opts.NModes)==1
    opts.NModes = 1:opts.NModes;
end
M_idx = length(opts.NModes);
for i = 1:M_idx
    mode_ind = [data.(opts.Mode)] == opts.NModes(i);
    mode_data = data(mode_ind);
    %sort the XAxis
    [~,idx] = sort([mode_data.(opts.XAxis)]);
    if ~isempty(idx)
    mode_data = mode_data(idx);
    x = [mode_data.(opts.XAxis)];
    y = opts.YScaling([mode_data.(opts.YAxis)]);
    plt_opts = namedargs2cell(pltOpts);
    pl(i) = plot(x,y,plt_opts{:});
    pl(i).Color = opts.Colors(mod(i-1,size(opts.Colors,1))+1,:);
    if ~isempty(opts.DisplayName)
        pl(i).DisplayName = [opts.DisplayName,' ',num2str(i)];
    else
        pl(i).Annotation.LegendInformation.IconDisplayStyle = 'off';
    end
    hold on
    end
end
end