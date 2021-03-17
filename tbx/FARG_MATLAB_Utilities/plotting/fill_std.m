function h_fill = fill_std(x,y,y_std,varargin)
% FILL_STD plots a filled polygon to represent the std about a value
%   x           - the 'x' data
%   y           - the 'y' data
%   y_std       - the semi-width of the polygon to plot at each x value
%   varargin    - a list of additional parameters passed to the 'fill'
%               function
% The function returns the plot handle of the filled area
%
% created by: Fintan Healy
% date: 17/03/2021
% email: fintan.healy@bristol.ac.uk
%

    % ensure input data is row vectors
    x = x(:);
    y = y(:);
    y_std = y_std(:);
    h_fill = fill([x;flipud(x)],...
            [(y+y_std);flipud(y-y_std)],'b',varargin{:});
end