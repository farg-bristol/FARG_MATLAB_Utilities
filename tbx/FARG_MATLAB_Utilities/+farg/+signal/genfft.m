function [f,P1,df] = genfft(y,Fs,varargin)
%% GENFFT generate the single sided fft of the single y
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
L = size(y,1);

if (~isempty(varargin))
    n = varargin{1};
else
    n = 2^nextpow2(L);
end
df = Fs/n;
Y = fft(y,n);
P2 = abs(Y/n);
P1 = P2(1:n/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
f = 0:(Fs/n):(Fs/2-Fs/n);
P1 = P1(1:n/2,:);
end