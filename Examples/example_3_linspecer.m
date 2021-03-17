% linspecer has been pulled off the file excahnge (see the line below). I
% have found it really useful for standardising plot colors to something
% that actually looks pretty and importantly is more colorblindness
% friendly (10% of men have some form of colorblindness, so a large amount of
% your audiance may appreciate colors being more spread out in 
% 'persepective space'!
%
% In this example 5 decaying sin waves are plotted in both the default
% colour scheme and linspecers default colour scheme
%
% example created by: FIntan Healy
% email: finatn.healy@bristol.ac.uk

% create data
x=0:0.01:10;
lines = 5;

y1 = cos(2*x).*exp(-0.25*x);
y2 = cos(2*x).*exp(-0.4*x);
y3 = cos(3*x).*exp(-0.8*x);
y4 = cos(1*x).*exp(-1.2*x);

% create color space
% you can choose between many differnt 2nd parameters for desired
% colorspaces

co = linspecer(4,'colorblind');
% co = linspecer(5,'gray');
% co = linspecer(5,'green');
% co = linspecer(5,'red');

% plot default colors
figure(1)
clf;
subplot(1,2,1)
p =plot(x',[y1',y2',y3',y4']);
arrayfun(@(x)set(x,'LineWidth',4),p)

% plot linspecer colors
sp = subplot(1,2,2);
p= plot(x',[y1',y2',y3',y4']);
arrayfun(@(x)set(x,'LineWidth',4),p)
set(gca,'colorOrder',co)
