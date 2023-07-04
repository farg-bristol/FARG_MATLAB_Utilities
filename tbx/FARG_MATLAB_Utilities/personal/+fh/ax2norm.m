%author: Girish Ratanpal, ECE, UVa.
%transform axes units to normalized units for 2-D figures only.
%works for linear,log scales and also reverse axes.
%DATE: JAN. 6, 2006. previous version: aug 12, 2005.
%
%
%FUNCTION DESCRIPTION:
% function [y_norm] = y_to_norm_v2(y_begin,y_end)
% function returns a 1x2 array, y_norm, with normalized unitsy_begin and
% y_end for the annotation object.
%
% function arguments:
%1. y_begin: enter the point where the annotation object begins on the axis
%         using axis units
%2. y_end: end of annotation object, again in axis units.
%
%EXAMPLE: first plot the graph on the figure.
%then use the following command for placing an arrow:
%h_object =
%annotation('arrow',x_to_norm_v2(x_begin,x_end),y_to_norm_v2(y_begin,y_end));
%******************************************
%CODE FOR x_norm_v2() IS COMMENTED AT THE END.
%******************************************
function [x,y] = ax2norm(x,y)
x = axis_to_norm(x,'X');
y = axis_to_norm(y,'Y');
end

function [y_norm] = axis_to_norm(y,XY)
h_axes = get(gcf,'CurrentAxes');    %get axes handle.
axesoffsets = get(h_axes,'Position');%get axes position on the figure.
if XY == 'X'
    ax_axislimits = get(gca, 'xlim');     %get axes extremeties.
    ax_dir = get(gca,'xdir');
    ax_scale = get(gca,'xScale');
    axesoffsets = axesoffsets([1,3]);
else
    ax_axislimits = get(gca, 'ylim');     %get axes extremeties.
    ax_dir = get(gca,'ydir');
    ax_scale = get(gca,'YScale');
    axesoffsets = axesoffsets([2,4]);
end

%get axes length
y_axislength_lin = abs(ax_axislimits(2) - ax_axislimits(1));
y_norm = zeros(size(y));
if strcmp(ax_dir,'normal')      %axis not reversed
    if strcmp(ax_scale,'log')
        %get axes length in log scale.
        y_axislength_log = abs(log10(ax_axislimits(2)) - log10(ax_axislimits(1)));
        for i = 1:length(y)
            y_norm(i) = axesoffsets(1)+axesoffsets(2)*abs(log10(y(i))-log10(ax_axislimits(1)))/(y_axislength_log);
        end
    elseif strcmp(ax_scale,'linear')%linear scale.
        %normalized distance from the lower left corner of figure.
        for i = 1:length(y)
            y_norm(i) = axesoffsets(1)+axesoffsets(2)*abs((y(i)-ax_axislimits(1))/y_axislength_lin);
        end
    else
        error('use only lin or log in quotes for scale')
    end

elseif strcmp(ydir,'reverse')  %axis is reversed
    if strcmp(ax_scale,'log')
        %get axes length in log scale.
        y_axislength_log = abs(log10(ax_axislimits(2)) - log10(ax_axislimits(1)));
        %normalized distance from the lower left corner of figure.
        for i = 1:length(y)
            y_norm(i) = axesoffsets(1)+axesoffsets(2)*abs(log10(ax_axislimits(2))-log10(y(i)))/(y_axislength_log);
        end
    elseif strcmp(ax_scale,'linear')
        %normalized distance from the lower left corner of figure.
        for i = 1:length(y)
            y_norm(i) = axesoffsets(1)+axesoffsets(2)*abs((ax_axislimits(2)-y(i))/y_axislength_lin);
        end
    else
        error('use only lin or log in quotes for scale')
    end
else
    error('use only r or nr in quotes for reverse')
end
end
%********************************************************
