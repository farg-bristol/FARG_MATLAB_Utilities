function [derivatives] = sgolayfilter(y, order, framelen, returnorders,dt)   
    % SGOLAYFILTER applies a Savitzky Golay Filter to a signal, and can
    % also be used to estimate derivatives
    % https://en.wikipedia.org/wiki/Savitzky%E2%80%93Golay_filter
    % Inputs:
    % - y : signal to be filtered
    % - order : order of sgolay filter to be applied
    % - framelen : size of frame which is convoluted along the signal
    % - return order : a list of which derivatives to return 0 being the
    %       filtered signal, 1 being the first derivative etc...
    % - dt : the sampling period of y
    %
    % Created by: Fintan Healy
    % email: fintan.healy@bristol.ac.uk
    % Date: 27/11/2022

    % apply filter
    [b,g] = sgolay(order,framelen);    

    % pad signal with reflection to avoid edge effects
    y = [y(1:framelen,:);y;y(end-framelen+1:end,:)];
    derivatives=zeros(size(y,1),length(returnorders));
    % 2d convolution filter to get the derivative at the desired order
    for i = 1:length(returnorders)
       derivatives(:,i) = conv2(y, factorial(returnorders(i))/(-dt)^returnorders(i) * g(:,returnorders(i)+1), 'same'); 
    end
    %remove reflection
    derivatives = derivatives(framelen+1:end-framelen,:);
end
