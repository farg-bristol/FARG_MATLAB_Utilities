function [fSelected,dSelected,mSelected] = runERACorrel(yi,samplingRate,fmax,alpha,nCorrel)
%% ERA using correlated input
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%
% Input : each column of yi is an input data channel
%% prep
dt = 1/samplingRate;
%% filter signal
%y = lowpass(yi,fmax,samplingRate);%% farg.signal.filterSignal(yi,dt,fmax);
y = yi;
outputs = size(y,2);
%% FFT
[fs,ys,df] = farg.signal.psd(y,samplingRate);
%[~,ys,df] = farg.era.chirp_dst(y,samplingRate,0,fmax);
%% prep ERA-DC
[y,~] = farg.era.genCorrelSignal(y,dt,nCorrel);
[H0,H1] = farg.era.genHankelMat(y,alpha);
[P,D,Q] = svd(H0,'econ'); % SVD of H0 matrix  (using the "skinny" version)
f = figure(10);
farg.era.plotSVD(D,f); % plot SVD

[fSelected,dSelected,mSelected] = farg.era.solveERA(H1,P,D,Q,dt,df,ys,fmax,outputs);
end
