function [V,Pitch,Yaw] = YZ_interp(V,opts)
%% YZ_interp_test return interpolants for working section velocity
% returns interpolants for the magnitude and pitch and yaw angle
arguments
    V
    opts.Method string {mustBeMember(opts.Method,{'nearest','natural','linear'})} = "natural";
    opts.Extrap string {mustBeMember(opts.Extrap,{'none','nearest','linear'})} = "none";
end
    folder = fileparts(mfilename('fullpath'));
    load(fullfile(folder,'SteadyData.mat'));
    Vs = [15,25,35];
    F = {};
    for i = 1:3
        tmp_res = farg.struct.filter(final_data,{{'U_inf',{'tol',Vs(i),1.5}},{'Radius',@(x)abs(x)>0}});
        y = [tmp_res.y]';
        z = [tmp_res.z]';
        us = [tmp_res.U]';
        pitchs = [tmp_res.pitch]';
        yaws = [tmp_res.yaw]';
        F{i,1} = scatteredInterpolant(y,z,us,opts.Method,opts.Extrap);
        F{i,2} = scatteredInterpolant(y,z,pitchs,opts.Method,opts.Extrap);
        F{i,3} = scatteredInterpolant(y,z,yaws,opts.Method,opts.Extrap);
    end
    %using the last y's and z's linearly interpolate  each velocity
    [Y,Z] = meshgrid(linspace(-2133.6/2,2133.6/2,101),linspace(-1524/2,1524/2,101));
    Ys = Y(:);
    Zs = Z(:);
    [Us,pitchs,yaws] = deal(zeros(3,length(Ys)));
    for i = 1:3
        Us(i,:) = F{i,1}(Ys,Zs); 
        pitchs(i,:) = F{i,2}(Ys,Zs); 
        yaws(i,:) = F{i,3}(Ys,Zs); 
    end
    %interp to new velocity
    delta = 0;
    if V<15
        waring('interpolating below V=15m/s assuming constant delta below 15');
        delta = V-15;
        V = 15;
    elseif V>35
        waring('interpolating above V=35m/s assuming constant delta above 35')
        delta = V-35;
        V = 35;
    end
    Us = interp1(Vs,Us,V)+delta;
    pitchs = interp1(Vs,pitchs,V);
    yaws = interp1(Vs,yaws,V);
    %make final interpolants
    V = scatteredInterpolant(Ys./1000,Zs./1000,Us',opts.Method,opts.Extrap);
    Pitch = scatteredInterpolant(Ys./1000,Zs./1000,pitchs',opts.Method,opts.Extrap);
    Yaw = scatteredInterpolant(Ys./1000,Zs./1000,yaws',opts.Method,opts.Extrap);
end