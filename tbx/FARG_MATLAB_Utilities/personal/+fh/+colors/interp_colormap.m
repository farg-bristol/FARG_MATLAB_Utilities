function new_colors = interp_colormap(colors,vars,opts)
arguments
    colors (:,3) double
    vars (:,1) double
    opts.limits (2,1) double = [nan,nan];
    opts.etas (2,1) double = [0,1];
end
if isnan(opts.limits(1))
    opts.limits(1) = min(vars);
end
if isnan(opts.limits(2))
    opts.limits(2) = max(vars);
end
% normalise variables
norm_vars = (vars-opts.limits(1))/(opts.limits(2)-opts.limits(1));
norm_vars(norm_vars<0) = 0;
norm_vars(norm_vars>1) = 1;
%convert to eta range
norm_vars = interp1([0 1],opts.etas,norm_vars,"linear");
% create color eta
eta = linspace(0,1,size(colors,1));
%interpolate colors
new_colors = interp1(eta',colors,norm_vars,"linear");
end

