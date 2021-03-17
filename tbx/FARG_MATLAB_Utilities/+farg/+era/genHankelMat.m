function [H0,H1] = genHankelMat(yi,alpha)
%% Generate Hankel Matrix
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%% Orient input matrix
y = yi'; % size(y) = [channels, nSamples];
%% Hankel matrix parameters
beta = size(y,2)-alpha;
H0 = HMat(y,0,alpha,beta);
H1 = HMat(y,1,alpha,beta);
end
%% Local function
function H = HMat(y,k,alpha,beta)
H = zeros(alpha,beta);
m = size(y,1);
for ii = 1:alpha
    iia = (ii-1)*m+1;
    iib = ii*m;
    for jj = 1:beta
        H(iia:iib,jj) = y(:,k+ii+jj-1);
    end
end
end