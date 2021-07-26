%% ERA Demo Script
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%
% Generate a predefined signal and use ERA to confirm freq & damping of the
% generated signal
%% ERA Method select
SW = 3; % ERA = 1, ERA-DC = 2, ERA using correlated input = 3
%% Generate test signal
f = [13.0,20.0,31.0]; % sine freq
a = [0.2,0.7,1.0]; % amplitude
z = [0.01,0.03,0.02]; % damping ratio
phi = 2*pi*[0.0,0.3,-0.5]; % phase
% main signal
samplingRate = 1000; % Hz
tEnd = 5.0; % end time, s
dt = 1/samplingRate;
t = 0:dt:tEnd;
y = zeros(size(t));
for ii = 1:length(f)
    w = 2*pi*f(ii);
    y = y+a(ii)*exp(-z(ii)*w*t).*sin(w*t+phi(ii));
end
% add noise
nzA = 0.1; % amplitude of noise
rng(61243998); % specify seed
nz = nzA*2*(rand(size(y))-0.5);
y = y+nz;
%% Plot generated signal
figure(1);
clf;
plot(t,y,'b-')
grid minor
xlabel('Time, s')
ylabel('Signal')
title('Test Signal')
%% Perform ERA
% For explanation of parameters, consult:
% Juang, Jer-Nan, Applied System Identification, 1994
fmax = 50.0; % lowpass filter corner freq
switch(SW)
    case(1)
        % ERA
        alpha = 80; % Hankel Matrix Num of Rows Multiplier
        [fSelected,dSelected] = farg.era.runERA(y',samplingRate,fmax,alpha);
    case(2)
        % ERA-DC
        alpha = 30; % Hankel Matrix Num of Rows Multiplier
        tau = 30; % number of sample lag
        xi = 4;
        zeta = 8;
        [fSelected,dSelected] = farg.era.runERADC(y',samplingRate,fmax,alpha,tau,xi,zeta);
    case(3)
        % ERA using correlated input
        nCorrel = 200; % Number of correlations
        alpha = 50; % Hankel Matrix Num of Rows Multiplier
        [fSelected,dSelected] = farg.era.runERACorrel(y',samplingRate,fmax,alpha,nCorrel);
end
%% Print results
fprintf('Input Freq(Hz) Input Damping(%%) ERA Freq(Hz) ERA Damping(%%)\n')
fprintf('%13.3f %16.2f %12.3f %14.2f\n',[f;z*100;[fSelected,dSelected]']);