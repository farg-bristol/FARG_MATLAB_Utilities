function [] = plotSVD(D)
%% Plot singular values
% Created by : R Cheung
% Contact: r.c.m.cheung@bristol.ac.uk
% Date: Oct 2019
DD = diag(D);
ddsum = sum(DD);   % sum of all singular values
dsum = cumsum(DD)/ddsum;
in1 = cumsum(ones(length(DD),1));
in2 = cumsum(ones(length(DD)-1,1));
Sratio = DD(1:length(DD)-1)./DD(2:length(DD));
% plots
figure
subplot(3,1,1)
semilogy(DD,'xb-')
ylabel('singular value')
xlabel('singular value index')
subplot(3,1,2)
plot(in1, dsum,'xb-' )
ylabel('cummulative sum ')
xlabel('singular value index')
subplot(3,1,3)
plot(in2, Sratio','ob-')
ylabel('successive ratio')
xlabel('singular value index')
end