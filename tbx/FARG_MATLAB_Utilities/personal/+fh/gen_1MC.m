function out = gen_1MC(f,A,tStart,t)
%GEN_1MC Summary of this function goes here
%   Detailed explanation goes here
out = zeros(size(t));
idx = t>tStart & t<tStart+1/f;
out(idx) = 0.5*A*(1-cos(2.*pi.*f.*(t(idx)-tStart)));
end

