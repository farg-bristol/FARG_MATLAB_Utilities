function [w_g] = wg_interp(V,F,A)
%WG_INTERP estimate w_g for a given set of gust parameters
if any(V<15)
    warning('No data below 15 m/s - assuming V=15')
    V(V<15) = 15;
end
if any(V>30)
    warning('No data below 15 m/s - assuming V=15')
    V(V>30) = 30;
end
% load data
folder = fileparts(mfilename('fullpath'));
load(fullfile(folder,'GustAmpData.mat'));

% at each velocity polyfit the change in Amp with gust Freq
Vs = 15:5:30;
Amps = [4,8,12,15];
vals = {};
for v_i = 1:length(Vs)
    ps = zeros(4,3);
    for a_i = 1:length(Amps)
        tmp = farg.struct.filter(gust_data,{{'V',Vs(v_i)},{'Amp',Amps(a_i)},{'F',@(x)x>2}});
        ps(a_i,:) = polyfit([tmp.F],[tmp.w],2);
    end
    vals{v_i} = ps;
end

w_g = zeros(length(V));
for i = 1:length(V)
    w_g_v = zeros(1,4);
    for v_i = 1:length(Vs)
        w_g_tmp = zeros(1,4);
        for j = 1:4
           w_g_tmp(j) =  polyval(vals{v_i}(j,:),F(i));
        end
        % interpolate for correct gust amplitude
        w_g_v(v_i) = polyval(polyfit(Amps,w_g_tmp,1),A(i));
    end
    %interpolate for coorect V
    w_g(i) = polyval(polyfit(Vs,w_g_v,1),V(i));
end
end

