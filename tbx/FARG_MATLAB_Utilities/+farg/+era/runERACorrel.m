function [fSelected,dSelected,plotHandle] = runERACorrel(yi,samplingRate,fmax,alpha,nCorrel,CrudeERA)
%% ERA using correlated input
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%
% Input : each column of yi is an input data channel
%% prep
dt = 1/samplingRate;
%% filter signal
y = lowpass(yi,fmax,samplingRate);%% farg.signal.filterSignal(yi,dt,fmax);
%% FFT
[~,ys,df] = farg.signal.psd(y,samplingRate);
%% prep ERA-DC
[y,~] = farg.era.genCorrelSignal(y,dt,nCorrel);
[H0,H1] = farg.era.genHankelMat(y,alpha);
[P,D,Q] = svd(H0,'econ'); % SVD of H0 matrix  (using the "skinny" version)
farg.era.plotSVD(D); % plot SVD

if ~exist('CrudeERA','var')
    [fSelected,dSelected] = farg.era.solveERA(H1,P,D,Q,dt,df,ys,fmax);
else
    [fSelected,dSelected,plotHandle] = farg.era.solveCrudeERA(H1,P,D,Q,dt,df,ys,fmax,3,10,0);
end
end
