function [fSelected,dSelected] = runERA(yi,samplingRate,fmax,alpha)
%% ERA
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
[~,ys,df] = farg.signal.psd(y,samplingRate);
%[~,ys,df] = farg.era.chirp_dst(y,samplingRate,0,fmax);
%% prep ERA-DC
[H0,H1] = farg.era.genHankelMat(y,alpha);
[P,D,Q] = svd(H0,'econ'); % SVD of H0 matrix  (using the "skinny" version)
f = figure(6);
f.Units = 'normalized';
f.Position = [0.0328,0.0009,0.4828,0.4204];
farg.era.plotSVD(D,'fHandle',f); % plot SVD
[fSelected,dSelected] = farg.era.solveERA(H1,P,D,Q,dt,df,ys,fmax);
end
