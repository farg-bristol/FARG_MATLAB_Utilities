function [fSelected,dSelected] = solveERA(H1,P,D,Q,dt,df,ys,fmax)
%% Run solution for a different number of truncated model values
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
%% Stabilisation Criteria
freqTol = 0.01;
dampTol = 0.05;
%% Find Freq & Damping
nStart = 2;
nEnd = floor(size(D,2)/2);
mSize = nEnd-nStart+1;
fmx = zeros(mSize,mSize);
dmx = zeros(mSize,mSize);

freq_red = [];
damp_red = [];
freq_blue = [];
damp_blue = [];
freq_black = [];
damp_black = [];

h = figure(3);
hold on
nn = 0;
for jj = nStart:nEnd
    nn = nn+1;
    % truncate the matrices
    kk = 2*jj; % jj*2 because conj pair of freq
    [omega,zeta] = ERA(H1,P(:,1:kk),D(1:kk,1:kk),Q(:,1:kk),dt);
    freq = omega(1:2:end)/2/pi; % extract one of the conj pair
    damp = zeta(1:2:end)*100; % extract one of the conj pair
    fmx(1:jj,jj) = freq;
    dmx(1:jj,jj) = damp;
    
    if(nn==1)
        plot(freq,jj*ones(size(freq)),'+k')
    else
        for ii = 1:jj
            f = fmx(ii,jj);
            d = dmx(ii,jj);
            if(d>0)
                [fmin,IDX] = min(abs(f-fmx(1:jj-1,jj-1))/f);
                if(fmin<freqTol)
                    ddif = abs(d-dmx(IDX,jj-1))/d;
                    if(ddif<=dampTol)
                        plot(f,jj,'Or') % root stabilised in freq & damping
                        if (d<50)
                            freq_red = [freq_red,f];
                            damp_red = [damp_red,d];
                        end
                    else
                        plot(f,jj,'^b') % root stabilised in freq only
                        if (dmx(ii,jj)<50)
                            freq_blue = [freq_blue,f];
                            damp_blue = [damp_blue,d];
                        end
                    end
                else
                    plot(f,jj,'+k') % root
                    if(dmx(ii,jj)<50)
                        freq_black = [freq_black,f];
                        damp_black = [damp_black,d];
                    end
                end
            end
        end
    end
    hold on
end
% scale s to fit in with stability plot
for ii = 1:size(ys,2)
    s = ys(1:end/2+1,ii);
    fs = (0:length(s)-1)*df;
    sc = nEnd/max(abs(s));
    plot(fs,sc*abs(s),'b-')
end
xlim([0,fmax]);
xlabel('Frequency, Hz')
ylabel('System Order')
title('How many modes need to be selected ?')
%%
nF = input('How many modes to select?    ');
fSelected = zeros(nF,1);
dSelected = zeros(nF,1);
for nn = 1:nF
    figure(h);
    title(['Select Mode ',int2str(nn)])
    [f,m] = ginput(1);
    m = round(m);
    [~,IDX] = min(abs(f-fmx(1:m,m)));
    f = fmx(IDX,m);
    d = dmx(IDX,m);
    plot(f,m,'*k')
    fprintf('Order = %d    Freq = %8.2f    Damping = %5.1f%%\n',m,f,d);
    fSelected(nn) = f;
    dSelected(nn) = d;
end
%% Plots
h = figure(4);
hold on
plot(freq_red,damp_red,'Or')
xlim([0,fmax]);
for nn = 1:nF
    xline(fSelected(nn),'k--');
end
maxDamp = max(damp_red);
for ii = 1:size(ys,2)
    s = ys(1:end/2+1,ii);
    fs = (0:length(s)-1)*df;
    sc = maxDamp/max(abs(s));
    plot(fs,sc*abs(s),'b-')
end
hold off
xlabel('Frequency, Hz')
ylabel('Damping, %')
title('How many modes need to be selected ?')
% plot 2
nF = input('How many modes to select?    ');
fSelected = zeros(nF,1);
dSelected = zeros(nF,1);
for nn = 1:nF
    figure(h);
    title(['Select Mode ',int2str(nn)])
    [f,d] = ginput(1);
    % find nearest red
    err = sqrt((freq_red-f).^2+(damp_red-d).^2);
    [~,IDX] = min(err);
    fSelected(nn) = freq_red(IDX);
    dSelected(nn) = damp_red(IDX);
end
%% Sort output
[fSelected,IDX] = sort(fSelected);
dSelected = dSelected(IDX);
end
%% Local functions
function [omega,zeta] = ERA(H1,P,D,Q,dt)
% define the system matrix and find the eigenvalues
Drt = D^(-0.5);
A = Drt*P'*H1*Q*Drt;
lambda = eig(A);    % in complex conj pairs: a + jb
a = log(lambda)/dt;
omega = abs(a);
zeta = -real(a)./omega;
[omega,IDX] = sort(omega);
zeta = zeta(IDX);
end