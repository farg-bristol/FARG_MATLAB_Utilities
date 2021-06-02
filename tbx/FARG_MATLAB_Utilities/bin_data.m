function [y_bin] = bin_data(x,y,x_bin,varargin)
% BIN_DATA takes the dataset {x,y} and returns the y data
% sorted into the x locations 'x_bins'
% in each bin the function 'func' is applied to each bin so that the output
% 'y_bin' is the same shape as 'x_bin'.
% By default 'func' can be empty and the function 'nanmean' will be applied
% to each bin, otherwise a custom anymous function or function handle can 
% be supplied (e.g. '@(x)max(x)' or @nanstd )
%
% created by: Fintan Healy
% date: 17/03/21
% email: fintan.healy@bristol.ac.uk
    function mean_x = nanmean(x)
        I = ~isnan(x);
        mean_x = mean(x(I));
    end
    p = inputParser();
    p.addOptional('func',@nanmean,@(x)isa(x,'function_handle'));
    p.parse(varargin{:});

    % calc distance between each x location and each bin
    dist = cell2mat(arrayfun(@(x)abs(x(:)-x_bin(:)'),x(:),'UniformOutput',false));

    % get index of closest bin to each x location
    [~,idx] = min(dist');

    % iterate over each bin and apply the 'binning function'
    y_bin = arrayfun(@(x)p.Results.func(y(idx==x)),cumsum(ones(size(x_bin))));
end

