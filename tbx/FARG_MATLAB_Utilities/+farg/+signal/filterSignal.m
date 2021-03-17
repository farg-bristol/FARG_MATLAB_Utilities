function [yf,f] = filterSignal(yi,dt,fmax)
%% Filter Signal using a lowpass filter
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
N = size(yi,1);
[Filter_f,~] = BWFilter(fmax,4,1/dt,N);% cut off freq, order, gain, sampling freq npts
[yf,f] = filtering(Filter_f,yi);
end
%% Local functions
function [Filter_f,wc] = BWFilter(fc,n,fs,N)
deltaF=fs/N;                % frequency step
fc=deltaF*round(fc/deltaF); % new cutoff frequency
wc=2*pi*fc;                 % cutoff pulsation
w_axis=[-2*pi*fs/2:deltaF*2*pi:2*pi*fs/2]';    % angular frequency axis
k=1:n;                                      
p_k=wc*exp(1i*pi*(n-1+2.*k)/(2*n));          % n poles in the 's' neg. half plane
Filter_f=1;
for c1=1:n
    Filter_f=Filter_f./((1i*w_axis-p_k(c1))/wc);
end
end
function [OUT_signal_t, OUT_signal_f] = filtering(Filter_f,x)
N = size(x,1);
if(mod(N,2)==1)
    N = N-1;
end
IN_signal_t = x(1:N,:);
% Filtering process:
IN_signal_f=fft(IN_signal_t/N);
Filter_f2=[Filter_f(N/2+1:N+1,:); Filter_f(2:N/2,:)];    % for MATLAB FFT
OUT_signal_f=IN_signal_f.*Filter_f2;            % filtering in frequency domain
OUT_signal_t=ifft(OUT_signal_f*N,'symmetric');  % output signal in time domain
end