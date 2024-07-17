%% example script to interpolate scattered data
% surface function to interrogate 
f = @(x,y) 100.*(y-x.^2).^2+(1-x).^2; % Rosenbrock function
% random points to interpolate between
x = rand(30,1)*4-2;
y = rand(30,1)*4-2;
% get value at our random points
z = f(x,y);
z = z./max(z);
% iterpolate the results
f_interp = scatteredInterpolant(x,y,z,'natural','none');
% create a mesh to plot the fitted surface
Xs = -2:0.025:2;
[X,Y] = meshgrid(Xs,Xs);
%iterpolate on mesh
Z = f_interp(X,Y);

%% plot result
f = figure(1);
clf;
hold on
s = surf(X,Y,Z);
s.EdgeAlpha = 0;
s.FaceAlpha = 0.5;
% s.AlphaData = 0.3;
plot3(x,y,z,'ko',MarkerFaceColor='k');
view(-50,29)