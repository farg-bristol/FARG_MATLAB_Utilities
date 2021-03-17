function [fSelected,dSelected] = runERADC(yi,samplingRate,fmax,alpha,tau,xi,zeta)
%% ERA-DC
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%
% Input : each column of yi is an input data channel
%% prep
dt = 1/samplingRate;
%% filter signal
[y,~] = farg.signal.filterSignal(yi,dt,fmax);
%% FFT
[~,ys,df] = farg.signal.genfft(y,samplingRate);
%% prep ERA-DC
[H0,H1] = farg.era.genCorrelHankelMat(y,alpha,tau,xi,zeta);
[P,D,Q] = svd(H0,'econ'); % SVD of H0 matrix  (using the "skinny" version)
farg.era.plotSVD(D); % plot SVD
[fSelected,dSelected] = farg.era.solveERA(H1,P,D,Q,dt,df,ys,fmax);
end
