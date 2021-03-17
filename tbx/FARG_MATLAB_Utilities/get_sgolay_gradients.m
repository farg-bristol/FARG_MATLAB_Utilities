function dy = get_sgolay_gradients(y,derivs,period,s_golay_order,s_golay_window_size)
%GET_SGOLAY_GRADIENTS get sgolay derivs of y
%   dy = GET_SGOLAY_GRADIENTS(y,derivs,s_golay_order,s_golay_window_size)
%       y - is a Mx1 column vector of data to filter
%       derivs - is a (Nx1) list of the derivatives to take a value of 0
%       period - period of the data
%       indicates justthe filter signal, 1 the 1st derivative etc..
%       s_golay_order - polynominal order of the sgolay filter
%       s_golay_window_size - window size of sgolay filter (must be odd)
%
%       returns dy - an (MxN) matrix where each column represents the
%       derivative of y as sepicifed in derivs
%

% create filter
[~,g] = sgolay(s_golay_order,s_golay_window_size);

% reflect the signal about the ends to remove edge effects
reflection_size = (s_golay_window_size-1)/2;
y = [2*y(1)-flipud(y(1:reflection_size,1));...
    y;...
    2*y(end)-flipud(y(end-reflection_size+1:end,1))];
            
% compute derivatives
dy = zeros(length(y),length(derivs));
for i = 1:length(derivs)
  dy(:,i) = conv(y, factorial(derivs(i))/(-period)^derivs(i) * g(:,derivs(i)+1), 'same');
end

% remove reflections from the result
dy = dy(reflection_size+1:end-reflection_size,:);
end

