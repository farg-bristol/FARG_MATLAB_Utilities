function [f,P1,df] = chirp_dst(y,fs,fmin,fmax,varargin)
%PSD [f,Pl,df] = psd(y,Fs,varargin) 
% generate the power spectial density of the input y, with a sampling
% frequency of 'Fs'
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
L = size(y,1);

if (~isempty(varargin))
    n = varargin{1};
else
    n = 2^nextpow2(L);
end
%czt
w = exp(-1i*2*pi*(fmax-fmin)/(n*fs));
a = exp(1i*2*pi*fmin/fs);
Y = czt(y,n,w,a);
P1 = abs(Y/n);
P1(2:end-1,:) = 2*P1(2:end-1,:);

fn = (0:n-1)'/n;
f = (fmax-fmin)*fn + fmin;
df = (fmax-fmin)/(n-1);
end