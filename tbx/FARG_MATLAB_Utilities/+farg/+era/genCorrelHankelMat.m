function [HH0,HH1] = genCorrelHankelMat(yi,alpha,tau,xi,zeta)
%% Generate Data-correlated Hankel Matrices
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%
% tau = number of sample lag
% size(HH0) = [zeta+1,eta+1]
%% Orient input matrix
y = yi'; % size(y) = [channels, nSamples];
%% Build matrices
% length of y in each correlation
segLength = size(y,2)-(xi+zeta)*tau;
% check alpha is OK
if((xi+zeta)>0)
    alpha = min(alpha,tau);
end
beta = segLength-alpha;
% build H0 & H1
m = size(y,1);
HT = HMat(y,0,alpha,beta)';
for ii = 1:xi+1
    iia = (ii-1)*alpha*m+1;
    iib = ii*alpha*m;
    for jj = 1:zeta+1
        jja = (jj-1)*alpha*m+1;
        jjb = jj*alpha*m;
        k0 = tau*(ii+jj-2);
        H0 = HMat(y,k0,alpha,beta);
        H1 = HMat(y,k0+1,alpha,beta);
        HH0(iia:iib,jja:jjb) = H0*HT;
        HH1(iia:iib,jja:jjb) = H1*HT;
    end
end
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