function [y,t] = genCorrelSignal(yi,dt,nCorrel)
%% Generate correlated signal
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
N = size(yi,1)-nCorrel;
y = zeros(nCorrel,size(yi,2));
for ii = 1:nCorrel
    for jj = 1:size(yi,2)
        y(ii,jj) = yi(1:N,jj)'*yi(ii:N+ii-1,jj);
    end
end
t = (0:nCorrel-1)*dt;
end