function [f,P1,df] = psd(y,Fs,opts)
arguments
    y (:,1) double
    Fs double
    opts.n = 2^nextpow2(size(y,1))
end
%PSD [f,Pl,df] = psd(y,Fs,varargin) 
% generate the power spectial density of the input y, with a sampling
% frequency of 'Fs'
n = opts.n;
df = Fs/n;
Y = fft(y,n);
P2 = abs(Y/n);
P1 = P2(1:n/2+1,:);
P1(2:end-1,:) = 2*P1(2:end-1,:);
f = 0:(Fs/n):(Fs/2-Fs/n);
f = f(:);
P1 = P1(1:n/2,:);
end