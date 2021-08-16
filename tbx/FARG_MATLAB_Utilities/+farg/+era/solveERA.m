function [fSelected,dSelected,mSelected] = solveERA(H1,P,D,Q,dt,df,ys,fmax,outputs)
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
shapes = {};

freq_red = [];
damp_red = [];
modeshapes_red = {};
order_red = [];
freq_blue = [];
damp_blue = [];
freq_black = [];
damp_black = [];

h = figure(3);
h.Units = 'normalized';
h.Position = [0.5,0,0.5,1];
clf;
hold on
nn = 0;
for jj = nStart:nEnd
    nn = nn+1;
    % truncate the matrices
    kk = 2*jj; % jj*2 because conj pair of freq
    [omega,zeta,modes] = ERA(H1,P(:,1:kk),D(1:kk,1:kk),Q(:,1:kk),dt,outputs);
    freq = omega(1:2:end)/2/pi; % extract one of the conj pair
    damp = zeta(1:2:end)*100; % extract one of the conj pair
    modes = modes(:,1:2:end);
    fmx(1:jj,jj) = freq;
    dmx(1:jj,jj) = damp;
    for i = 1:size(modes,2)
        shapes{i,jj-1} = modes(:,i);
    end
    subplot(5,1,1:2)
    hold on
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
                        %if (d<90)
                            freq_red = [freq_red,f];
                            damp_red = [damp_red,d];
                            order_red = [order_red,jj];
                            modeshapes_red{end+1} = shapes{ii,jj-1};
                        %end
                    else
                        plot(f,jj,'^b') % root stabilised in freq only
                        %if (dmx(ii,jj)<90)
                            freq_blue = [freq_blue,f];
                            damp_blue = [damp_blue,d];
                        %end
                    end
                else
                    plot(f,jj,'+k') % root
                    %if(dmx(ii,jj)<90)
                        freq_black = [freq_black,f];
                        damp_black = [damp_black,d];
                    %end
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
%xlabel('Frequency, Hz')
ylabel('System Order')
title('How many modes need to be selected ?')
%%
%% Plots
subplot(5,1,3:5)
hold on
scatter(freq_red,damp_red,[],order_red)
xlim([0,fmax]);
maxDamp = max(damp_red);
if maxDamp > 70
    maxDamp = 70;
end
for ii = 1:size(ys,2)
    s = ys(1:end/2+1,ii);
    fs = (0:length(s)-1)*df;
    sc = maxDamp/max(abs(s));
    plot(fs,sc*abs(s),'b-')
end
ylim([0,maxDamp*1.1])
hold off
colormap(flipud(hot))
%c = colorbar;
%c.Label.String = 'Order';
xlabel('Frequency, Hz')
ylabel('Damping, %')
title('How many modes need to be selected ?')
%nF = input('How many modes to select?    ');
% plot 2

fSelected = [];
dSelected = [];
mSelected = {};
while true
    figure(h);
    title(sprintf('Select Mode %.0f',length(fSelected)+1))
    [f,d] = ginput(1);
    if isempty(f)
        break
    else
        % find nearest red
        err = sqrt((freq_red-f).^2+(damp_red-d).^2);
        [~,IDX] = min(err);
        fSelected(end+1) = freq_red(IDX);
        dSelected(end+1) = damp_red(IDX);
        mSelected{end+1} = modeshapes_red{IDX};
    end
end
%% Sort output
[fSelected,IDX] = sort(fSelected);
dSelected = dSelected(IDX);
mSelected = mSelected(IDX);
end
%% Local functions
function [omega,zeta,modeshapes] = ERA(H1,P,D,Q,dt,outputs)
% define the system matrix and find the eigenvalues
Drt = D^(-0.5);
A = Drt*P'*H1*Q*Drt;
C = P*D; C = C(1:outputs,:);
[Vectors,Values]=eig(A);       % Eigenvalues and Eigenvectors
lambda = diag(Values);    % in complex conj pairs: a + jb
s = log(lambda)/dt;
omega = abs(s);
zeta = -real(s)./omega;
[omega,IDX] = sort(omega);
zeta = zeta(IDX);
Vectors = Vectors(:,IDX);
modeshapes = C*Vectors;
end